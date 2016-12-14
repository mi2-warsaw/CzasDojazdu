conn <- dbConnect(dbDriver("SQLite"), "../dane/czas_dojazdu.db")
dane <- dbGetQuery(
  conn,
  "SELECT cena, adres, dzielnica, content, lon, lat, data_dodania
  FROM gumtree_warszawa_pokoje_02
  WHERE cena <> '' and adres <> '' and dzielnica <> ''
  AND content <> '' and lon <> '' and lat <> '' and data_dodania <> ''"
) %>%
  filter(cena != "NA") %>%
  mutate(cena = cena %>% as.numeric(),
         data_dodania = data_dodania %>% as.Date(),
         lon = lon %>% as.numeric(),
         lat = lat %>% as.numeric()) %>%
  filter(cena > 200,
         nchar(adres) > 2,
         between(lat, 52.098673, 52.368653),
         between(lon, 20.851555, 21.282646))

dbDisconnect(conn)

lang <- "lang/pl.json" %>%
  fromJSON() %>%
  rapply(gsub, pattern = "\n[[:space:]]*", replacement = " ", how = "list")

dashboardHeader <- dashboardHeader(
    title = lang$header$title,
    titleWidth = 300,
    dropdownMenu(
      type = "notifications",
      badgeStatus = "success",
      messageItem(
         nrow(dane),
         lang$header$offers,
         icon("photo")
      )
    ),
    dropdownMenu(
      type = "messages",
      messageItem(
        from = lang$header$project$from,
        message = lang$header$project$message,
        href = "https://github.com/mi2-warsaw/CzasDojazdu",
        icon = icon("git")
      ),
      messageItem(
        from = lang$header$data$from,
        message = lang$header$data$message,
        icon = icon("calendar"),
        time = dane$data_dodania %>% max() %>% as.character()
      ), 
      messageItem(
        from = "Michał Cisek",
        href = "https://github.com/michalcisek",
        message = lang$header$profile
      ),
      messageItem(
        from = "Aleksandra Brodecka",
        href = "https://github.com/abrodecka",
        message = lang$header$profile
      ),
      messageItem(
        from = "Tomasz Mikołajczyk",
        href = "https://github.com/mikolajjj",
        message = lang$header$profile
      ),
      messageItem(
        from = "Krzysztof Słomczyński",
        href = "https://github.com/krzyslom",
        message = lang$header$profile
      ),
      messageItem(
        from = "Marcin Kosiński",
        href = "https://github.com/MarcinKosinski",
        message = lang$header$profile
      ),
      messageItem(
        from = lang$header$team$from,
        message = lang$header$team$message,
        href = "https://github.com/orgs/mi2-warsaw/teams/wczasowicze",
        icon = icon("group")
      )
    )
)