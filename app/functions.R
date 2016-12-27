# Load items
getItem <- function(name, item) {
  path <- switch(item,
                 message = "elements/header/",
                 menu = "elements/sidebar/")
  paste0(path, name, ".json") %>%
    jsonlite::fromJSON() %>%
    lapply(function(x) {
      if (
        x %in% c("TRUE", "FALSE", "NULL") | grepl("::|lang\\$|\\(data", x)
      ) {
        x  %>% parse(text = .) %>% eval()
      } else {
        x
      }
    })
}

# # Load items
# getItem <- function(name, item, ...) {
#   path <- switch(item,
#                  message = "elements/header/",
#                  menu = "elements/sidebar/")
#   subs <- list(...)
#   if (subs %>% length() > 0) {
#     subs <- subs %>%
#       lapply(function(x) {
#         x %>%
#           paste0(path, name, "_", ., ".json") %>%
#           parseEval() %>%
#           do.call(shinydashboard::menuSubItem, .)
#       })
#   }
#   main <- paste0(path, name, ".json") %>%
#     parseEval()
#     # do.call(shinydashboard::menuSubItem, testing$...)
#   c(main, ... = list(subs))
# }

parseEval <- function(json) {
  json %>%
    jsonlite::fromJSON() %>%
    lapply(function(x) {
      if (
        x %in% c("TRUE", "FALSE", "NULL") | grepl("::|lang\\$|\\(data", x)
      ) {
        x  %>% parse(text = .) %>% eval()
      } else {
        x
      }
    })
}

# Prepare datatable
prepDT <- function(lang, data) {
  data %>%
    select(dzielnica, adres, cena, data_dodania, link) %>%
    # mutate(link = link %>%
    #          lapply(function (x) {
    #            x %>%
    #              shiny::tags$a(href = ., "link")
    #          }) %>%
    #          unlist()) %>%
    mutate(link = link %>%
             paste0("<a href='", ., "' target = '_blank'>link</a>")) %>%
    setNames(names(.) %>%
               gsub("_", " ", .) %>%
               gsub("(^|[[:space:]])([a-ż])",
                    "\\1\\U\\2",
                    .,
                    perl = TRUE)) %>%
    DT::datatable(
      options = list(
        language = lang$datatable
      ),
      escape = FALSE
    )
}

# Load language
loadLang <- function(lang) {
  translation <- lang %>%
    paste0("lang/", ., ".json", collapse = "") %>%
    fromJSON() %>%
    rapply(gsub, pattern = "\n[[:space:]]*", replacement = " ", how = "list")
  DT <- lang %>%
    paste0("lang/", ., "DT.json", collapse = "") %>%
    fromJSON() %>%
    list() %>%
    setNames("datatable")
  c(translation, DT)
}