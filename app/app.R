library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)
library(ggmap)
library(stringi)
library(RSQLite)
library(jsonlite)

conn <- dbConnect(dbDriver("SQLite"), "../dane/czas_dojazdu.db")
dane <- dbGetQuery(
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

dbDisconnect(conn)

lang <- "lang/pl.json" %>%
  fromJSON() %>%
  rapply(gsub, pattern = "\n[[:space:]]*", replacement = " ", how = "list")

subfolder <- "elements/"
list.files(subfolder) %>%
  sapply(function(x) {
    x %>%
      paste0(subfolder, .) %>%
      source()
  })

ui <- dashboardPage(
  skin = "black",
  dashboardHeader,
  dashboardSidebar,
  dashboardBody
)

server <- function(input, output, session) {
  
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$go, {
    v$doPlot <- input$go
  })
  
  dane2 <- reactive({
    dane %>% 
      filter(between(cena, input$cena[1], input$cena[2]),
             between(data_dodania, input$data[1], input$data[2]))
  })
  
  dane3 <- reactive({
    # typ <- switch(input$srodek_trans,
    #               lang$sidebar$transport$driving = "driving",
    #               lang$sidebar$transport$bicycling = "bicycling",
    #               lang$sidebar$transport$walking = "walking")
    if (input$srodek_trans == lang$sidebar$transport$driving) {
      typ <- "driving"
    } else if (input$srodek_trans == lang$sidebar$transport$bicycling) {
      typ <- "bicycling"
    } else {
      typ <- "walking"
    }
    # typ <- switch(input$srodek_trans,
    #               Samochód = "driving",
    #               Rower = "bicycling",
    #               Pieszo = "walking")
    czas <- mapdist(paste("Warszawa", dane2()$adres), 
                    paste("Warszawa", input$lokalizacja), 
                    typ,
                    "simple") %>%
      unique()
    dane2() %>%
      filter(czas$minutes %>% as.integer() <= input$czas_doj)
  })
  
  output$dane_debug <- renderText({
    HTML(
      paste0(
        "<font color=\"#FFA500\"><b>",
        dane2() %>% nrow(),
        "</b></font>"
      )
    )
  })
  
  output$content <- DT::renderDataTable({
    if (v$doPlot) {
      dane3() %>%
        select(dzielnica, adres, cena, data_dodania, link) %>%
        datatable()
    } else {
      datatable(
        data.frame(
          dzielnica = "", adres = "", cena = "", czas = "", data_dodania = ""
        )
      )
    }}, escape = FALSE)
  
  output$mymap <- renderLeaflet({
    content_lok <- paste(sep = "<br/>",
                         lang$sidebar$content_lok,
                         input$lokalizacja)
    geocode <- paste("Warszawa", input$lokalizacja) %>% geocode()
    
    blue <- "blue.png"
    green <- "green.png"
    
    if (v$doPlot == FALSE) {
      leaflet() %>%
        addTiles() %>%
        addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green,
                      iconSize = 40),
          popup = content_lok
        )
    } else {
      leaflet() %>%
        addTiles() %>%
        addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green,
                      iconSize = 40),
          popup = content_lok
        ) %>%
        addMarkers(
          dane3()$lon,
          dane3()$lat,
          icon = list(iconUrl = blue, iconSize = 40),
          popup = dane3()$content
        ) %>%
        addMarkers(
          geocode$lon,
          geocode$lat,
          icon = list(iconUrl = green, iconSize = 40),
          popup = content_lok
        )
    }
  })
}

shinyApp(ui, server)