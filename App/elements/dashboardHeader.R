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


dashboardHeader <- dashboardHeader(
    title = "Pokoje a Czas Dojazdu",
    titleWidth = 300,
    dropdownMenu(
      type = "notifications",
      badgeStatus = "success",
      messageItem(
         from = nrow(dane),
         message = "Ofert",
         icon = icon("photo")
      )
    ),
    dropdownMenu(
      type = "messages",
      messageItem(
         from = "Projekt",
         message = "Kliknij by przejść.",
         href = "https://github.com/mi2-warsaw/CzasDojazdu",
         icon = icon("git")
      ),
      messageItem(
         from = "Dane",
         message = "Aktualne na dzień",
         icon = icon("calendar"),
         time = as.character(max(as.Date(dane$data_dodania)))
      ),
      messageItem(
         from = "Michał Cisek",
         href = "https://github.com/michalcisek",
         message = "Kliknij by przejść na profil"
      ),
      messageItem(
         from = "Aleksandra Brodecka",
         href = "https://github.com/abrodecka",
         message = "Kliknij by przejść na profil"
      ),
      messageItem(
         from = "Tomasz Mikołajczyk",
         href = "https://github.com/mikolajjj",
         message = "Kliknij by przejść na profil"
      ),
      messageItem(
         from = "Marcin Kosiński",
         href = "https://github.com/MarcinKosinski",
         message = "Kliknij by przejść na profil"
      ),
      messageItem(
         from = "Zespół na GitHubie",
         message = "Kliknij by przejść",
         href = "https://github.com/orgs/mi2-warsaw/teams/wczasowicze",
         icon = icon("group")
      )
    ),
    dropdownMenu(
      type = "tasks",
      badgeStatus = "success",
      taskItem(value = 70, color = "green",
        "Kompletowanie danych"
      ),
      taskItem(value = 95, color = "green",
        "Weryfikacja danych"
      ),
      taskItem(value = 50, color = "yellow",
        "Wizualizacja danych"
      ),
      taskItem(value = 100, color = "aqua",
        "Automatyzacja"
      ),
      taskItem(value = 10, color = "red",
        "Dokumentacja"
      ),
      taskItem(value = 60, color = "yellow",
        "Całkowicie"
      )
    )
   )