library(dplyr)
library(ggmap)


shinyServer(function(input, output) {
  
  output$ui <- renderUI({
    if (is.null(input$miasto))
      return()
    
    switch(input$miasto,
           "Warszawa" = checkboxGroupInput("dzielnica", "Dzielnica: ", 
                                           choices = as.character(sort(unique(subset(dane.df, dane.df$miasto =="Warszawa")$district)))),
           "Wroclaw" = checkboxGroupInput("dzielnica", "Dzielnica: ", 
                                          choices = as.character(sort(unique(subset(dane.df, dane.df$miasto =="Wroclaw")$district))))
    )
  })
  
  
  output$content <- renderTable({
    dane.df <- dane.df %>% filter(miasto == input$miasto)
    
    dane.df <- dane.df[order(dane.df$district, decreasing = F),]
    
    # do poprawy: wybor dzielnicy
    # dane.df <- dane.df[dane.df$district == input$dzielnica, ] 
    
    dane.df <- dane.df %>% filter(cena >= input$cena_min & cena <= input$cena_max)
    
    dane.df <- dane.df %>% filter(rodzaj == input$rodzaj_lok)
    
    
    if (input$srodek_trans =="Samochod") typ = "driving"
    if (input$srodek_trans =="Rower") typ = "bicycling"
    if (input$srodek_trans =="Pieszo") typ = "walking"
    
    odleglosci <- mapdist(from = paste(dane.df$miasto, dane.df$adres), 
                          to = input$lokalizacja, 
                          mode = typ,
                          output = "simple")
    
    czas <- as.integer(odleglosci$minutes)
    dane.new <- cbind(dane.df, czas)
    dane.new <- dane.new %>% filter(czas <= input$czas_doj)
    
    dane.new
  })
  
  #############################################
  output$plot <- renderPlot({
    
    dane.df <- dane.df %>% filter(miasto == input$miasto)
    
    # do poprawy: wybor dzielnicy
    # dane.df <- dane.df[dane.df$district == input$dzielnica, ] 
    
    dane.df <- dane.df %>% filter(cena >= input$cena_min & cena <= input$cena_max)
    
    dane.df <- dane.df %>% filter(rodzaj == input$rodzaj_lok)
    
    
    if (input$srodek_trans =="Samochod") typ = "driving"
    if (input$srodek_trans =="Rower") typ = "bicycling"
    if (input$srodek_trans =="Pieszo") typ = "walking"
    
    odleglosci <- mapdist(from = paste(dane.df$miasto, dane.df$adres), 
                          to = input$lokalizacja, 
                          mode = typ,
                          output = "simple")
    
    czas <- as.integer(odleglosci$minutes)
    dane.new <- cbind(dane.df, czas)
    dane.new <- dane.new %>% filter(czas <= as.integer(input$czas_doj))
    
    
    geocode <- ggmap::geocode(paste(dane.new$miasto, dane.new$adres))
    geocode$id <- dane.new$adres
    geocode_lok <- geocode(input$lokalizacja)
    mapa <- ggmap::get_map(location = c(geocode_lok$lon, geocode_lok$lat), zoom = 11)
    
    ggmap(mapa) +
      geom_point(data = geocode, aes(x = lon, y = lat), col = "red", size=4) + 
      geom_label(aes(label = id), data = geocode) +
      geom_point(data = geocode_lok, aes(x = lon, y = lat), col = "red", size=4) + 
      geom_label(aes(label = "start"), data = geocode_lok)
    
    
  })
  
})