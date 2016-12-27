# Template
# menuItem <- list(
#   text = "",
#   icon = "NULL",
#   badgeLabel = "NULL",
#   badgeColor = "green",
#   tabName = "NULL",
#   href = "NULL",
#   newtab = "TRUE",
#   selected = "NULL"
# )

# tabName not compatible with href. Both incompatible with sub-items.

menuItem <- list(
  text = "",
  icon = "NULL",
  badgeLabel = "NULL",
  badgeColor = "green",
  tabName = "NULL",
  href = "NULL",
  newtab = "TRUE",
  selected = "NULL"
)

name <- ""

menuItem %>%
  jsonlite::toJSON(pretty = TRUE) %>%
  cat(file = paste0("app/elements/sidebar/", name, ".json"))