

shinyUI(fluidPage(
  titlePanel("Czas dojazdu"),
  fluidRow(
    
    sidebarPanel(
      selectInput("miasto", "Wybierz miasto",
                  as.character(unique(dane.df$miasto))
      ),
      
      uiOutput("ui"),
      textInput("lokalizacja", "Lokalizacja: ", 
                value = "Warszawa, Koszykowa 75"),
      
      textInput("czas_doj", "Maksymalny czas dojazdu w min. :",
                value="30"),
      
      selectInput("srodek_trans", "Srodek transportu: ", 
                  choices = c("Samochod" , "Rower" , "Pieszo"), selected = "Samochod"),
      
      textInput("cena_min", "Cena minimalna :",
                value="0"),
      
      textInput("cena_max", "Cena maksymalna :",
                value="1200"),
      
      selectInput("rodzaj_lok", "Rodzaj lokalu: ", 
                  choices = as.character(unique(dane.df$rodzaj)), selected = "Pokoj")
    )
    ,
    
    mainPanel(
      tableOutput("content"),
      plotOutput('plot')
    )
  )
))
