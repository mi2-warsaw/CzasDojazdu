library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)
library(ggmap)
library(stringi)
library(RSQLite)
library(jsonlite)

source("functions.R")

conn <- RSQLite::dbConnect(dbDriver("SQLite"), "../dane/czas_dojazdu.db")
dane <- RSQLite::dbGetQuery(
  conn,
  "SELECT cena, adres, dzielnica, content, lon, lat, data_dodania, link
  FROM gumtree_warszawa_pokoje_02
  WHERE cena <> '' and adres <> '' and dzielnica <> ''
  AND content <> '' and lon <> '' and lat <> '' and data_dodania <> ''"
) %>%
  filter(cena != "NA") %>%
  mutate(cena = cena %>% as.numeric(),
         data_dodania = data_dodania %>% as.Date(),
         lon = lon %>% as.numeric(),
         lat = lat %>% as.numeric()) %>%
  filter(cena > 200,
         nchar(adres) > 2,
         between(lat, 52.098673, 52.368653),
         between(lon, 20.851555, 21.282646)) %>%
  group_by(adres) %>%
  top_n(1, -cena) %>%
  top_n(1, link) %>%
  ungroup()
RSQLite::dbDisconnect(conn)

lang <- loadLang("pl")

subfolder <- "elements/"
list.files(path = subfolder, pattern = "*.R") %>%
  sapply(function(x) {
    x %>%
      paste0(subfolder, .) %>%
      source()
  })

ui <- shinydashboard::dashboardPage(
  header = shinydashboard::dashboardHeader(
    title = uiOutput("title"),
    titleWidth = 300,
    shinydashboard::dropdownMenuOutput("headerMessages"),
    shinydashboard::dropdownMenuOutput("headerNotifications")
  ),
  sidebar = shinydashboard::dashboardSidebar(
    dbSidebarLanguage("language"),
    shinydashboard::sidebarMenu(
      id = "items",
      shinydashboard::menuItemOutput("sidebar")
    ),
    shiny::uiOutput("widgets")
  ),
  body = shiny::uiOutput("body")
)

server <- function(input, output, session) {
  
  lang <- shiny::eventReactive(input$language,
                        switch(input$language,
                               PL = "pl",
                               EN = "en") %>% loadLang())
  
  shiny::observe({
    shiny::updateSelectInput(session, "language", lang()$sidebar$language)
    shinydashboard::updateTabItems(session, "items", "cel")
  })
  
  shiny::observeEvent(input$language, {
    output$title <- shiny::renderText(
      lang()$header$title
    )
    
    output$headerMessages <- shinydashboard::renderMenu({
      dbHeader(
        lang = lang(),
        data = dane,
        type = "messages",
        badgeStatus = "success",
        name = "offers"
      )
    })
    
    output$headerNotifications <- shinydashboard::renderMenu({
      dbHeader(
        lang = lang(),
        data = dane,
        type = "notifications",
        badgeStatus = "success",
        name = c("project", "data", "brodecka", "cisek", "kosinski",
                 "mikolajczyk", "slomczynski", "team")
      )
    })
    
    output$sidebar <- shinydashboard::renderMenu({
      dbSidebar(lang())
    })
    
    output$widgets <- shiny::renderUI(
      dbSidebarWidgets(lang())
    )
    
    output$body <- shiny::renderUI(
      dbBody(lang())
    )
  })
  
  v <- shiny::reactiveValues(doPlot = FALSE)
  
  shiny::observeEvent(input$go, {
    v$doPlot <- input$go
  })
  
  dane2 <- shiny::reactive(
    dane %>% 
      filter(between(cena, input$cena[1], input$cena[2]),
             between(data_dodania, input$data[1], input$data[2]))
  )
  
  dane3 <- shiny::reactive({
    # typ <- switch(input$srodek_trans,
    #               lang$sidebar$transport$driving = "driving",
    #               lang$sidebar$transport$bicycling = "bicycling",
    #               lang$sidebar$transport$walking = "walking")
    if (input$srodek_trans == lang()$sidebar$transport$driving) {
      typ <- "driving"
    } else if (input$srodek_trans == lang()$sidebar$transport$bicycling) {
      typ <- "bicycling"
    } else {
      typ <- "walking"
    }
    # typ <- switch(input$srodek_trans,
    #               Samochód = "driving",
    #               Rower = "bicycling",
    #               Pieszo = "walking")
    czas <- ggmap::mapdist(paste("Warszawa", dane2()$adres), 
                    paste("Warszawa", input$lokalizacja), 
                    typ,
                    "simple") %>% unique()
    dane2() %>%
      filter(czas$minutes %>% as.integer() <= input$czas_doj)
  })
  
  output$dane_debug <- shiny::renderText(
    HTML(
      paste0(
        "<font color=\"#FFA500\"><b>",
        dane2() %>% nrow(),
        "</b></font>"
      )
    )
  )
  
  output$content <- DT::renderDataTable({
    if (v$doPlot) {
      prepDT(lang = lang(), data = dane3())
    } else {
      prepDT(lang = lang(), data = dane[FALSE, ])
    }})
  
  output$mymap <- leaflet::renderLeaflet({
    content_lok <- paste(sep = "<br/>",
                         lang()$sidebar$content_lok,
                         input$lokalizacja)
    geocode <- paste("Warszawa", input$lokalizacja) %>% ggmap::geocode()
    
    blue <- "blue.png"
    green <- "green.png"
    
    if (v$doPlot == FALSE) {
      leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green,
                      iconSize = 40),
          popup = content_lok
        )
    } else {
      leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green,
                      iconSize = 40),
          popup = content_lok
        ) %>%
        leaflet::addMarkers(
          dane3()$lon,
          dane3()$lat,
          icon = list(iconUrl = blue, iconSize = 40),
          popup = dane3()$content
        ) %>%
        leaflet::addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green, iconSize = 40),
          popup = content_lok
        )
    }
  })
}

shiny::shinyApp(ui, server)