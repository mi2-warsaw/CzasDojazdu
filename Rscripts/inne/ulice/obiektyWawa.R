# Dane ze strony UM Warszawy: http://www.ulice.um.warszawa.pl/wyszukiwanie/faces/obiekty.xhtml
# Eksportujemy do *.xls, otwieramy, usuwamy 3 pierwsze wiersze i pierwszą kolumnę. Eksportujemy do CSV.

library(dplyr)

obiekty <- read.csv("warszawa_obiekty.csv", stringsAsFactors = FALSE)

# cywilizujemy nazwy zmiennych
colnames(obiekty) <- c("name.long", "name.short", "name.gen", "district", "type")

# nowa zmienna bez skrótu 'ul. '
obiekty$adres <- obiekty$name.short
obiekty$adres <- gsub("ul. ", "", obiekty$adres)
obiekty$adres <- gsub("Al. ", "al. ", obiekty$adres)

# powrót do pliku danych
write.csv(obiekty, file = "dicts/wawa_obiekty.csv", row.names = FALSE)
