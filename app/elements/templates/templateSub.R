# Template
# menuSubItem <- list(
#   text = "",
#   tabName = "NULL",
#   href = "NULL",
#   newtab = "TRUE",
#   icon = "shiny::icon('angle-double-right')",
#   selected = "NULL"
# )

# tabName not compatible with href.

menuSubItem <- list(
  text = "text",
  tabName = "NULL",
  href = "NULL",
  newtab = "TRUE",
  icon = "shiny::icon('angle-double-right')",
  selected = "NULL"
)

name <- ""
subname <- ""

menuSubItem %>%
  jsonlite::toJSON(pretty = TRUE) %>%
  cat(file = paste0("app/elements/sidebar/", name, "_", subname, ".json"))