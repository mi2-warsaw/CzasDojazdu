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



dashboardSidebar <-
  dashboardSidebar(
    sidebarMenu(
      menuItem(
       "O projekcie",
       tabName = "info",
       icon = icon("info"),
       menuSubItem(
         "Cel",
         tabName = "cel",
         icon = icon("trophy")
       ),
       menuSubItem(
         "Ludzie",
         tabName = "ludzie",
         icon = icon("users")
       ),
       menuSubItem(
         "Dane",
         tabName = "dane",
         icon = icon("database")
       )
      ),
      menuItem(
        "Pokoje",
        tabName = "pokoje",
        icon = icon("graduation-cap"),
        badgeLabel = "new",
        badgeColor = "yellow"
      ),
      menuItem(
        "Mieszkania",
        tabName = "mieszkania",
        icon = icon("hotel"),
        badgeLabel = "TODO",
        badgeColor = "green"
      ),
      menuItem(
        "Wykresy",
        tabName = "wykresy",
        icon = icon("area-chart"),
        badgeLabel = "TODO",
        badgeColor = "green"
      ),
      selectInput(
        "dzielnica",
        "Wybierz dzielnicę: ",
        choices = as.character(sort(unique(dane$dzielnica))),
        multiple = TRUE,
        selected = as.character(sort(unique(dane$dzielnica)))[1]
      ),
      textInput(
        "lokalizacja",
        "Lokalizacja docelowa: ",
        value = "Koszykowa 75"
      ),
     sliderInput(
       "czas_doj",
       "Maksymalny czas dojazdu w minutach :",
       min = 0,
       max = 120,
       value= 30
     ),
     selectInput(
       "srodek_trans",
       "Wybierz środek transportu: ",
       choices = c("Samochod" , "Rower" , "Pieszo"),
       selected = "Samochod"
     ),
     sliderInput(
       "cena",
       "Wybierz zakres cenowy :",
       min = 0,
       max = 4000,
       value=c(800,1500)
     ),
     sliderInput(
       "data",
       "Wybierz datę ogłoszenia (liczba ostatnich dni)",
       min = 0,
       max = 7,
       value= 3
     ),
     actionButton("go", "Pokaż lokalizacje")
    )
  )