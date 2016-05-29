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
       "About a project",
       tabName = "info",
       icon = icon("info"),
       menuSubItem(
         "Goal",
         tabName = "cel",
         icon = icon("trophy")
       ),
       menuSubItem(
         "Co-authors",
         tabName = "ludzie",
         icon = icon("users")
       ),
       menuSubItem(
         "Data",
         tabName = "dane",
         icon = icon("database")
       )
      ),
      menuItem(
        "Rooms to let",
        tabName = "pokoje",
        icon = icon("graduation-cap"),
        badgeLabel = "new",
        badgeColor = "yellow"
      ),
      menuItem(
        "Apartments to let",
        tabName = "mieszkania",
        icon = icon("hotel"),
        badgeLabel = "TODO",
        badgeColor = "green"
      ),
      menuItem(
        "Analysis",
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
        "Location : ",
        value = "Koszykowa 75"
      ),
     sliderInput(
       "czas_doj",
       "Maximum commuting time :",
       min = 0,
       max = 90,
       value= 30, 
       step = 5
     ),
     selectInput(
       "srodek_trans",
       "Mode of transportation : ",
       choices = c("Car" , "Bike" , "On foot"),
       selected = "Car"
     ),
     sliderInput(
       "cena",
       "Price range :",
       min = 0,
       max = 4000,
       value=c(800,1500),
       step = 50
     ),
     dateRangeInput(
       "data",
       "Offers on the following days",
       min = as.character(Sys.Date() - 7),
       max = as.character(Sys.Date()),
       start = as.character(Sys.Date() - 3),
       end = as.character(Sys.Date())
     ),
     actionButton("go", "Show location"),
     div(HTML('<p style="font-size:24px; font-family:Verdana;"align="justify"><strong><a href="http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/pl/">Polish Version </a></strong>'))
    )
  )
