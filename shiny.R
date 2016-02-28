library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)
library(dplyr)
library(ggmap)
library(stringi)

dane.df <- read.csv("dane.csv")


ui <- navbarPage(theme = "bootstrap.min4.css", 
                 
                 titlePanel(HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> Czas dojazdu </h2></p>') , windowTitle = "Czas dojazdu"),
                 
                 
                 tabPanel(tags$h3(tags$b("O projekcie")),
                          
                          div(
                            HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> O projekcie Czas dojazdu</h2></p>'),
                            HTML('<p style="font-size:24px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Aplikacja Czas dojazdu jest super. Dziala swietnie, nie ma lepszej. Polecam. </p>'),
                            style = 'max-width:1000px;width:98%;margin:auto;')),       
                 
                 
                 
                 
                 
                 tabPanel(tags$h3(tags$b("Lokalizacje")),
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput("miasto", "Wybierz miasto",
                                          as.character(unique(dane.df$miasto))),
                              
                              uiOutput("ui"),
                              textInput("lokalizacja", "Lokalizacja: ", 
                                        value = "Warszawa, Koszykowa 75"),
                              
                              sliderInput("czas_doj", "Maksymalny czas dojazdu w min. :",
                                          min = 0, max = 120, value= 30),
                              
                              selectInput("srodek_trans", "Srodek transportu: ", 
                                          choices = c("Samochod" , "Rower" , "Pieszo"), selected = "Samochod"),
                              
                              sliderInput("cena", "Zakres cenowy :", min = 0, max = 4000,
                                          value=c(800,1500)),
                              
                              selectInput("rodzaj_lok", "Rodzaj lokalu: ", 
                                          choices = as.character(unique(dane.df$rodzaj)), selected = "Pokoj")
                              
                              
                            ),
                            mainPanel(
                              leafletOutput("mymap" , height = 800)
                            )
                          )
                 ),
                 
                 tabPanel(tags$h3(tags$b("Szczegolowe informacje")),
                          DT::dataTableOutput('content')                         
                          
                 ))



server <- function(input, output, session) {
  
  output$ui <- renderUI({
    if (is.null(input$miasto))
      return()
    
    switch(input$miasto,
           "Warszawa" = checkboxGroupInput("dzielnica", "Dzielnica: ", 
                                           choices = as.character(sort(unique(stri_trim(subset(dane.df, dane.df$miasto =="Warszawa")$district)))),
                                           selected = as.character(sort(unique(subset(dane.df, dane.df$miasto =="Warszawa")$district)))[1]),
           "Wroclaw" = checkboxGroupInput("dzielnica", "Dzielnica: ", 
                                          choices = as.character(sort(unique(subset(dane.df, dane.df$miasto =="Wroclaw")$district))))
    )
  })
  
  
  dane.df2  <- reactive({
    dane.df <- dane.df %>% filter(miasto == input$miasto,
                                  as.character(district) %in% unlist(input$dzielnica),
                                  cena >= input$cena[1] & cena <= input$cena[2], 
                                  rodzaj == input$rodzaj_lok)
    dane.df
  })
  
  
  dane.df3 <-  reactive({
    
    if (input$srodek_trans =="Samochod") typ = "driving"
    if (input$srodek_trans =="Rower") typ = "bicycling"
    if (input$srodek_trans =="Pieszo") typ = "walking"
    czas <- mapdist(from = paste(dane.df2()$miasto, dane.df2()$adres), 
                    to = input$lokalizacja, 
                    mode = typ,
                    output = "simple")
    czas <- as.integer(czas$minutes)
    dane.df <- cbind(dane.df2(), czas)
    dane.df <- dane.df %>% filter(czas <= input$czas_doj)
    dane.df
  })
  
  
  output$content <- DT::renderDataTable(
    
    DT::datatable(dane.df3()[, c("miasto", "district", "adres", "cena","rodzaj", "czas")])
    
  )
  
  
  output$mymap <- renderLeaflet({
    
    geocode <- geocode(input$lokalizacja)
    
    content_lok <- paste( sep = "<br/>", 
                          "Twoja lokalizacja", 
                          input$lokalizacja)
    
    
    content <- paste( sep = "<br/>",
                      paste0("<b><a href='",dane.df3()$link,"'>link</a></b>"),
                      paste("Cena: ", dane.df3()$cena),
                      paste("Adres: ", dane.df3()$adres)
    )
    
    
    blue = "blue.png"
    green = "green.png"
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(dane.df3()$lon, dane.df3()$lat, icon = list(
        iconUrl = blue, iconSize = 40
      ), popup = content) %>%
      addMarkers(geocode$lon, geocode$lat, icon = list(
        iconUrl = green, iconSize = 40), popup = content_lok
      )
    
    
  })
  
  
}

shinyApp(ui, server)
