dbHeader <- function(lang, data, type, badgeStatus, name) {
  item <- "message"
  shinydashboard::dropdownMenu(
    type = type,
    badgeStatus = badgeStatus,
    .list = mapply(function(n, i) {
      do.call(shinydashboard::messageItem, getItem(name = n, item = i))
    },
    name,
    item,
    SIMPLIFY = FALSE)
  )
}