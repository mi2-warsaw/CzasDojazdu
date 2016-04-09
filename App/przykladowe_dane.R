# przykladowe dane z bazy danych
library(RSQLite)
polaczenie <- dbConnect( dbDriver( "SQLite" ), "App/czas_dojazdu.db" )
dbGetQuery(polaczenie, "select * from gumtree_warszawa_pokoje") -> example_data
dbDisconnect(polaczenie)

### Jak nie ma dresu to ustawiaja sie wspolrzedne
### warszawy
### ale ogolnie usuwalbym takie dane