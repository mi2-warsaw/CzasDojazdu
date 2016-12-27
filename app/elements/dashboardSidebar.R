dbSidebarLanguage <- function(id) {
  shiny::selectInput(
    inputId = id,
    label = "Wybierz język:",
    choices = c("PL", "EN")
  )
}

dbSidebar <- function(lang, data) {
  items <- list(
    about = getItem("about", "menu"),
    about_goal = getItem("about_goal", "menu"),
    about_authors = getItem("about_authors", "menu"),
    about_data = getItem("about_data", "menu"),
    rooms = getItem("rooms", "menu"),
    apartments = getItem("apartments", "menu"),
    analysis = getItem("analysis", "menu")
  )
  # ) %>%
  #   rapply(eval, classes = "call", how = "replace")
  # Z wpisanym w json quote() nie działa. Próba ewaluacji już w tym miejscu
  # zamiast przy wywołaniu funkcji.
  
  shinydashboard::sidebarMenu(
    shinydashboard::menuItem(
      text = items$about$text %>% eval(),
      icon = items$about$icon,
      badgeLabel = items$about$badgeLabel,
      badgeColor = items$about$badgeColor,
      tabName = items$about$tabName,
      href = items$about$href,
      newtab = items$about$newtab,
      selected = items$about$selected,
      shinydashboard::menuSubItem(
        text = items$about_goal$text %>% eval(),
        tabName = items$about_goal$tabName,
        href = items$about_goal$href,
        newtab = items$about_goal$newtab,
        icon = items$about_goal$icon,
        selected = items$about_goal$selected
      ),
      shinydashboard::menuSubItem(
        text = items$about_authors$text %>% eval(),
        tabName = items$about_authors$tabName,
        href = items$about_authors$href,
        newtab = items$about_authors$newtab,
        icon = items$about_authors$icon,
        selected = items$about_authors$selected
      ),
      shinydashboard::menuSubItem(
        text = items$about_data$text %>% eval(),
        tabName = items$about_data$tabName,
        href = items$about_data$href,
        newtab = items$about_data$newtab,
        icon = items$about_data$icon,
        selected = items$about_data$selected
      )
    ),
    shinydashboard::menuItem(
      text = items$rooms$text %>% eval(),
      icon = items$rooms$icon,
      badgeLabel = items$rooms$badgeLabel,
      badgeColor = items$rooms$badgeColor,
      tabName = items$rooms$tabName,
      href = items$rooms$href,
      newtab = items$rooms$newtab,
      selected = items$rooms$selected
    ),
    shinydashboard::menuItem(
      text = items$apartments$text %>% eval(),
      icon = items$apartments$icon,
      badgeLabel = items$apartments$badgeLabel,
      badgeColor = items$apartments$badgeColor,
      tabName = items$apartments$tabName,
      href = items$apartments$href,
      newtab = items$apartments$newtab,
      selected = items$apartments$selected
    ),
    shinydashboard::menuItem(
      text = items$analysis$text %>% eval(),
      icon = items$analysis$icon,
      badgeLabel = items$analysis$badgeLabel,
      badgeColor = items$analysis$badgeColor,
      tabName = items$analysis$tabName,
      href = items$analysis$href,
      newtab = items$analysis$newtab,
      selected = items$analysis$selected
    )
  )
}

# Niestety, na obecną chwilę nie da się wywołać menuItem() z argumentem .list.
# Powyżej zastosowano standardowe rozwiązanie.
# dbSidebar <- function(lang) {
#   sidebarMenu(
#     do.call(
#       shinydashboard::menuItem,
#       list(
#         getItem(lang = lang, data = NULL, "about", "menu"),
#         do.call(
#           shinydashboard::menuSubItem,
#           getItem(lang = lang, data = NULL, "about_goal", "menu")
#         ),
#         do.call(
#           shinydashboard::menuSubItem,
#           getItem(lang = lang, data = NULL, "about_authors", "menu")
#         ),
#         do.call(
#           shinydashboard::menuSubItem,
#           getItem(lang = lang, data = NULL, "about_data", "menu")
#         )
#       )
#     ),
#     do.call(
#       shinydashboard::menuItem,
#       getItem(lang = lang, data = NULL, "rooms", "menu")
#     ),
#     do.call(
#       shinydashboard::menuItem,
#       getItem(lang = lang, data = NULL, "apartments", "menu")
#     ),
#     do.call(
#       shinydashboard::menuItem,
#       getItem(lang = lang, data = NULL, "analysis", "menu")
#     )
#   )
# }

dbSidebarWidgets <- function(lang) {
  list(
    shiny::textInput(
      inputId = "lokalizacja",
      label = lang$sidebar$location,
      value = "Koszykowa 75"
    ),
    shiny::sliderInput(
      inputId = "czas_doj",
      label = lang$sidebar$commuting,
      min = 0,
      max = 90,
      value = 30, 
      step = 5
    ),
    shiny::selectInput(
      inputId = "srodek_trans",
      label = lang$sidebar$transport$label,
      choices = c(
        lang$sidebar$transport$driving,
        lang$sidebar$transport$bicycling,
        lang$sidebar$transport$walking
      ),
      selected = lang$sidebar$transport$driving
    ),
    shiny::sliderInput(
      inputId = "cena",
      label = lang$sidebar$price,
      min = 0,
      max = 4000,
      value = c(800, 1500),
      step = 50
    ),
    shiny::dateRangeInput(
      inputId = "data",
      label = lang$sidebar$date,
      start = Sys.Date() - 3,
      end = Sys.Date(),
      min = Sys.Date() - 7,
      max = Sys.Date(),
      language = lang$sidebar$lang,
      separator = lang$sidebar$separator
    ),
    shiny::actionButton(
      inputId = "go",
      label = lang$sidebar$button
    )
  )
}