# Prepare datatable
prepDT <- function(data) {
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
    datatable(escape = FALSE)
}