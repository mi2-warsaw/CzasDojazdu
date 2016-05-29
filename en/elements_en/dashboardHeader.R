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


dashboardHeader <- dashboardHeader(
    title = "Commuting time of rooms to let",
    titleWidth = 350,
    dropdownMenu(
      type = "notifications",
      badgeStatus = "success",
      messageItem(
         from = nrow(dane),
         message = "Offers",
         icon = icon("photo")
      )
    ),
    dropdownMenu(
      type = "messages",
      messageItem(
         from = "Project",
         message = "Click to proceed",
         href = "https://github.com/mi2-warsaw/CzasDojazdu",
         icon = icon("git")
      ),
      messageItem(
         from = "Data",
         message = "Valid untill",
         icon = icon("calendar"),
         time = as.character(max(as.Date(dane$data_dodania)))
      ),
      messageItem(
         from = "Michał Cisek",
         href = "https://github.com/michalcisek",
         message = "Click to proceed on a profile"
      ),
      messageItem(
         from = "Aleksandra Brodecka",
         href = "https://github.com/abrodecka",
         message = "Click to proceed on a profile"
      ),
      messageItem(
         from = "Tomasz Mikołajczyk",
         href = "https://github.com/mikolajjj",
         message = "Click to proceed on a profile"
      ),
      messageItem(
         from = "Marcin Kosiński",
         href = "https://github.com/MarcinKosinski",
         message = "Click to proceed on a profile"
      ),
      messageItem(
         from = "GitHub team",
         message = "Click to proceed",
         href = "https://github.com/orgs/mi2-warsaw/teams/wczasowicze",
         icon = icon("group")
      )
    
    )
   )
