conn <- dbConnect( dbDriver( "SQLite" ), "../dane/czas_dojazdu.db" )
dane <- list()
 dbGetQuery(conn, 'select cena, adres, dzielnica,  content, lon, lat, data_dodania
            from gumtree_warszawa_pokoje 
            where cena <> "" and adres <> "" and dzielnica <> "" 
            and content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane#[[1]]
 
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
          lat = as.numeric(as.character(lat))) %>%
   filter(cena > 200,
          nchar(adres) > 2,
          lat <= 52.368653,
          lat >= 52.098673,
          lon <= 21.282646,
          lon >= 20.851555)
   
 
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
        "Analizy",
        tabName = "analizy",
        icon = icon("area-chart"),
        badgeLabel = "prototype",
        badgeColor = "maroon"
      ),
#       selectInput(
#         "dzielnica",
#         "Wybierz dzielnicę: ",
#         choices = as.character(sort(unique(dane$dzielnica))),
#         multiple = TRUE,
#         selected = as.character(sort(unique(dane$dzielnica)))[1]
#       ),
      textInput(
        "lokalizacja",
        "Lokalizacja: ",
        value = "Koszykowa 75"
      ),
     sliderInput(
       "czas_doj",
       "Maksymalny czas dojazdu:",
       min = 0,
       max = 90,
       value= 30, 
       step = 5
     ),
     selectInput(
       "srodek_trans",
       "Środek transportu: ",
       choices = c("Samochod" , "Rower" , "Pieszo"),
       selected = "Samochod"
     ),
     sliderInput(
       "cena",
       "Zakres cenowy :",
       min = 0,
       max = 4000,
       value=c(800,1500),
       step = 50
     ),
     dateRangeInput(
       "data",
       "Oferty z dni",
       min = as.character(Sys.Date() - 7),
       max = as.character(Sys.Date()),
       start = as.character(Sys.Date() - 3),
       end = as.character(Sys.Date())
     ),
     actionButton("go", "Pokaż lokalizacje"),
     div(HTML('<p style="font-size:24px; font-family:Verdana;"align="justify"><strong><a href="http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/en/">English Version </a></strong>'))
    )
  )
