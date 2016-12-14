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

dashboardSidebar <- dashboardSidebar(
  sidebarMenu(
    selectInput(
      "language",
      "Wybierz język",
      c("polski", "english")
    ),
    menuItem(
      lang$sidebar$about$item,
      tabName = "info",
      icon = icon("info"),
      menuSubItem(
        lang$sidebar$about$subitem$goal,
        tabName = "cel",
        icon = icon("trophy")
      ),
      menuSubItem(
        lang$sidebar$about$subitem$authors,
        tabName = "ludzie",
        icon = icon("users")
      ),
      menuSubItem(
        lang$sidebar$about$subitem$data,
        tabName = "dane",
        icon = icon("database")
      )
    ),
    menuItem(
      lang$sidebar$rooms,
      tabName = "pokoje",
      icon = icon("graduation-cap"),
      badgeLabel = "new",
      badgeColor = "yellow"
    ),
    menuItem(
      lang$sidebar$apartments,
      tabName = "mieszkania",
      icon = icon("hotel"),
      badgeLabel = "TODO",
      badgeColor = "green"
    ),
    menuItem(
      lang$sidebar$analysis,
      tabName = "analizy",
      icon = icon("area-chart"),
      badgeLabel = "prototype",
      badgeColor = "maroon"
    ),
    textInput(
      "lokalizacja",
      lang$sidebar$location,
      value = "Koszykowa 75"
    ),
    sliderInput(
      "czas_doj",
      lang$sidebar$commuting,
      min = 0,
      max = 90,
      value = 30, 
      step = 5
    ),
    selectInput(
      "srodek_trans",
      lang$sidebar$transport$label,
      choices = c(
        lang$sidebar$transport$driving,
        lang$sidebar$transport$bicycling,
        lang$sidebar$transport$walking
      ),
      selected = lang$sidebar$transport$driving
    ),
    sliderInput(
      "cena",
      lang$sidebar$price,
      min = 0,
      max = 4000,
      value = c(800, 1500),
      step = 50
    ),
    dateRangeInput(
      "data",
      lang$sidebar$date,
      min = Sys.Date() - 7,
      max = Sys.Date(),
      start = Sys.Date() - 3,
      end = Sys.Date()
    ),
    actionButton("go", "Pokaż lokalizacje")
  )
)