.libPaths(c('/home/mkosinski/R/x86_64-pc-linux-gnu-library/3.2', .libPaths()))
library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)
library(ggmap)
library(stringi)
library(RSQLite)

 
 conn <- dbConnect( dbDriver( "SQLite" ), "../dane/czas_dojazdu.db" )
dane <- list()
 dbGetQuery(conn, 'select cena, adres, dzielnica,  content, lon, lat, data_dodania
            from gumtree_warszawa_pokoje 
            where cena <> "" and adres <> "" and dzielnica <> "" 
            and content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane[[1]]
 
 dbGetQuery(conn, 'select cena, adres, dzielnica,  content, lon, lat, data_dodania
            from olx_warszawa_pokoje 
            where cena <> "" and adres <> "" and dzielnica <> "" 
            and content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane[[2]]
 
 dane <- do.call("rbind", dane)
 
 dbDisconnect(conn)

#  content <- dane[[1]]$content
#  content <- content[1:6]
#  cena <- c(800, 1000, 900, 850, 1000, 750)
# data_dodania <- c("2016-04-08","2016-04-08", "2016-04-10", "2016-04-06", "2016-04-06", "2016-04-07")
#  adres <- c("Abrahama 10", "Koszykowa 3", "Anielewicza" , "Banacha 2", "Saska 10", "Racławicka 11")
#  dzielnica <- c("Praga", "Srodmiescie", "WOla", "Ochota", "Praga", "Mokotów")
#  geo <- ggmap::geocode(paste("Warszawa", adres))
#  lon <- geo$lon
#  lat <- geo$lat
#  dane <- data.frame(cena, adres, dzielnica, geo, lon, lat, content, data_dodania)
#  dane

source('elements/dashboardHeader.R')
source('elements/dashboardSidebar.R')
 
ui <- dashboardPage(
  skin = "black",
  dashboardHeader,
  dashboardSidebar,
  dashboardBody(
    tabItems(
      tabItem(
        "pokoje",
        leafletOutput("mymap" , height = 800)
      ),
      tabItem(
        "cel",
        div(
            HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> O projekcie Czas Dojazdu</h2></p>'),
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Aplikacja Czas Dojazdu umożliwia wyszukanie pokoi do wynajęcia, których czas dojazdu nie przekracza danych parametrów od wybranego miejsca. Informacje o pokojach pobierane są z popularnych portali z ogłoszeniami.</p>'),
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Jeżeli uważasz, że aplikację można poprawić, albo masz jakiekolwiek pytania bądź sugestie, proszę zostaw wiadomość w poniższym panelu.</p>'),
            style = 'max-width:1000px;width:98%;margin:auto;'),
            
        div(id="disqus_thread",
            HTML("<script>
                   (function() {  // DON'T EDIT BELOW THIS LINE
                       var d = document, s = d.createElement('script');
                       
                       s.src = '//mi2-czasojazdu.disqus.com/embed.js';
                       
                       s.setAttribute('data-timestamp', +new Date());
                       (d.head || d.body).appendChild(s);
                   })();
               </script>
               <noscript>Please enable JavaScript to view the <a href='https://disqus.com/?ref_noscript' rel='nofollow'>comments powered by Disqus.</a></noscript>")
         )
      ),
      tabItem(
        "dane",
        DT::dataTableOutput('content') 
      )

    )
  )
) 
 
 
# ui <- navbarPage(theme = "bootstrap.min4.css", 
#                   
#  titlePanel(HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> Czas dojazdu </h2></p>') , windowTitle = "Czas dojazdu"),
#  
#  
#  tabPanel(tags$h3(tags$b("O projekcie")),
#           
#           div(
#             HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> O projekcie Czas dojazdu</h2></p>'),
#             HTML('<p style="font-size:24px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Aplikacja Czas dojazdu jest super. Dziala swietnie, nie ma lepszej. Polecam. </p>'),
#             style = 'max-width:1000px;width:98%;margin:auto;')),       
#  
#  
#  
#  
#  
#  tabPanel(tags$h3(tags$b("Lokalizacje")),
#           sidebarLayout(
#             sidebarPanel(
#               
#               checkboxGroupInput("dzielnica", "Wybierz dzielnicę: ", 
#               choices = as.character(sort(unique(dane$dzielnica)))),
#               
#               textInput("lokalizacja", "Lokalizacja docelowa: ", 
#                         value = "Koszykowa 75"),
#               
#               sliderInput("czas_doj", "Maksymalny czas dojazdu w minutach :",
#                           min = 0, max = 120, value= 30),
#               
#               selectInput("srodek_trans", "Wybierz środek transportu: ", 
#                           choices = c("Samochod" , "Rower" , "Pieszo"), selected = "Samochod"),
#               
#               sliderInput("cena", "Wybierz zakres cenowy :", min = 0, max = 4000,
#                           value=c(800,1500)),
#             
#               sliderInput("data", "Wybierz datę ogłoszenia (liczba ostatnich dni)",
#                           min = 0, max = 7, value= 3),
#               
#               actionButton("go", "Pokaż lokalizacje")
#             ),
#             
#             mainPanel(
#               leafletOutput("mymap" , height = 800)
#             )
#           )
#  ),
#  
#  tabPanel(tags$h3(tags$b("Szczegolowe informacje")),
#           DT::dataTableOutput('content')                         
#           
#  ))



server <- function(input, output, session) {
    
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$go, {
    v$doPlot <- input$go
  })

  dane2  <- reactive({
    dane <- dane %>% filter( as.character(dzielnica) %in% unlist(input$dzielnica),
                            as.numeric(cena) >= input$cena[1] & as.numeric(cena) <= input$cena[2],
                            as.Date(data_dodania)>=(Sys.Date() - input$data) ) 
    dane
  })
  
  
  dane3 <-  reactive({
    
    if (input$srodek_trans =="Samochod") typ = "driving"
    if (input$srodek_trans =="Rower") typ = "bicycling"
    if (input$srodek_trans =="Pieszo") typ = "walking"
    czas <- mapdist(from = paste("Warszawa", dane2()$adres), 
                    to = paste("Warszawa", input$lokalizacja), 
                    mode = typ,
                    output = "simple")
    czas <- as.integer(czas$minutes)
    dane <- cbind(dane2(), czas)
    dane<- dane %>% filter(czas <= input$czas_doj)
    dane
  })
  
  
  output$content <- DT::renderDataTable(
    if (v$doPlot == FALSE) { 
      DT::datatable(data.frame(dzielnica = "", adres = "", cena="", czas="", data_dodania = ""))
    } else {
    DT::datatable(dane3()[, c("dzielnica", "adres", "cena", "czas", "data_dodania")])
    }
  )
  
  
  output$mymap <- renderLeaflet({
    
    content_lok <- paste( sep = "<br/>", 
                          "Twoja lokalizacja", 
                          input$lokalizacja)    
    geocode <- geocode(paste("Warszawa", input$lokalizacja))
    
    blue = "blue.png"
    green = "green.png"
    
    if (v$doPlot == FALSE) { 
      leaflet()%>%
      addTiles() %>% addMarkers(geocode$lon, geocode$lat, icon = list(
                                 iconUrl = green, iconSize = 40), popup = content_lok
                               )
    } else {
    
    
    
    leaflet() %>%
      addTiles() %>%
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
