library(jsonlite)
key <- "8c923598-2106-4c7c-9fe4-5741b6e88568"
adres <- "https://api.um.warszawa.pl/api/action/wfsstore_get?id=8c05e43a-504d-4680-bb75-e240858aad5c&apikey="
lista <- fromJSON(paste0(adres, key))
