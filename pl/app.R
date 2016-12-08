#.libPaths(c('/home/mkosinski/R/x86_64-pc-linux-gnu-library/3.2', .libPaths()))
library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)
library(ggmap)
library(stringi)
library(RSQLite)

conn <- dbConnect(dbDriver("SQLite"), "../dane/czas_dojazdu.db")
dane <- list()
 dbGetQuery(conn, 'SELECT cena, adres, dzielnica,  content, lon, lat, data_dodania, link
            FROM gumtree_warszawa_pokoje_02 
            WHERE cena <> "" and adres <> "" and dzielnica <> "" 
            AND content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane#[[1]]
 
 # dbGetQuery(conn, 'select cena, adres, dzielnica,  content, lon, lat, data_dodania
 #            from olx_warszawa_pokoje 
 #            where cena <> "" and adres <> "" and dzielnica <> "" 
 #            and content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane[[2]]
 # 
 # dane <- do.call("rbind", dane) %>%
 dane <- dane %>%
   filter(cena != "NA") %>% 
   mutate(cena = as.numeric(as.character(cena)),
          data_dodania = as.Date(data_dodania),
          lon = as.numeric(as.character(lon)),
          lat = as.numeric(as.character(lat)),
          link = as.character(link)) %>%
   filter(cena > 200,
          nchar(adres) > 2,
          lat <= 52.368653,
          lat >= 52.098673,
          lon <= 21.282646,
          lon >= 20.851555) %>%
   group_by(adres) %>%
   top_n(1, -cena) %>%
   top_n(1, link) %>%
   ungroup
   
 
 dbDisconnect(conn)


source('elements/dashboardHeader.R')
source('elements/dashboardSidebar.R')
source('elements/dashboardBody.R')
 
 
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

  dane2  <- reactive({
    dane <- dane %>% 
      filter(cena >= input$cena[1] & cena <= input$cena[2],
             as.Date(data_dodania) >=  as.Date(input$data[[1]]),
             as.Date(data_dodania) <=  as.Date(input$data[[2]]))
    dane
  })
  
  
  dane3 <-  reactive({
    
    adresy <- dane2()$adres
    
    if (input$srodek_trans =="Samochod") typ = "driving"
    if (input$srodek_trans =="Rower") typ = "bicycling"
    if (input$srodek_trans =="Pieszo") typ = "walking"
    czas <- mapdist(from =  paste("Warszawa", adresy), 
                    to = paste("Warszawa", input$lokalizacja), 
                    mode = typ,
                    output = "simple") %>% unique
    # czas <- as.integer(czas$minutes)
    # dane <- cbind(dane2(), czas)
    # dane<- dane %>% filter(czas <= input$czas_doj)
    dane2()[as.integer(czas$minutes) <= input$czas_doj, ] #%>% unique()
  })
  
  
    output$dane_debug <-  renderPrint({
    
    # adrsy <- dane2()$adres
    # 
    # if (input$srodek_trans =="Samochod") typ = "driving"
    # if (input$srodek_trans =="Rower") typ = "bicycling"
    # if (input$srodek_trans =="Pieszo") typ = "walking"
    # czas <- mapdist(from =  adrsy, 
    #                 to = paste("Warszawa", input$lokalizacja), 
    #                 mode = typ,
    #                 output = "simple") %>% unique
    # # czas <- as.integer(czas$minutes)
    # # dane <- cbind(dane2(), czas)
    # # dane<- dane %>% filter(czas <= input$czas_doj)
    dane2() %>% nrow()
  })
    

  
  output$content <- DT::renderDataTable({
    if (v$doPlot == FALSE) { 
      DT::datatable(data.frame(dzielnica = "", adres = "", cena="", czas="", data_dodania = ""))
    } else {
    DT::datatable(dane3()[, c("dzielnica", "adres", "cena", "data_dodania", "link")])
    }
  }, escape = FALSE
  )
  
  
  output$mymap <- renderLeaflet({
    
    content_lok <- paste( sep = "<br/>", 
                          "Twoja lokalizacja", 
                          input$lokalizacja)    
    geocode <- geocode(paste("Warszawa", input$lokalizacja))
    
    blue = "blue.png"
    green = "green.png"
    
    if (v$doPlot == FALSE) { 
      leaflet() %>%
      addTiles() %>% 
        addMarkers(geocode$lon,
                   geocode$lat,
                   icon = 
                     list(iconUrl = green,
                          iconSize = 40),
                   popup = content_lok)
    } else {
    
    
    
    leaflet() %>%
      addTiles() %>%
              addMarkers(geocode$lon,
                   geocode$lat,
                   icon = 
                     list(iconUrl = green,
                          iconSize = 40),
                   popup = content_lok) %>%
      addMarkers(dane3()$lon, dane3()$lat, icon = list(
        iconUrl = blue, iconSize = 40
      ), popup = dane3()$content) %>%
      addMarkers(geocode$lon, geocode$lat, icon = list(
        iconUrl = green, iconSize = 40), popup = content_lok
      )
    }
    
  })
  
}

shinyApp(ui, server)


