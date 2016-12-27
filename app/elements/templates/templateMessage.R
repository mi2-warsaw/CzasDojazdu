# Template
# messageItem <- list(
#   from = "",
#   message = "",
#   icon = "shiny::icon('user')",
#   time = "NULL",
#   href = "NULL"
# )

messageItem <- list(
  from = "",
  message = "",
  icon = "shiny::icon('user')",
  time = "NULL",
  href = "NULL"
)

name <- ""

messageItem %>%
  jsonlite::toJSON(pretty = TRUE) %>%
  cat(file = paste0("app/elements/header/", name, ".json"))