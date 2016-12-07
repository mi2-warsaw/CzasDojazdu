polaczenie <- dbConnect(dbDriver("SQLite"), "dane/czas_dojazdu.db")

data_od <- Sys.Date() - 3

dbGetQuery(polaczenie,
           paste0("SELECT * FROM gumtree_warszawa_pokoje_02",
                  " WHERE data_dodania >=", data_od)
           ) -> adresy_w_bazce_gumtree

dbGetQuery(polaczenie,
           paste0("SELECT * FROM olx_warszawa_pokoje",
                  " WHERE data_dodania >=", data_od)
           ) -> adresy_w_bazce_olx

adresy_w_bazce_olx %>% select(-opis, -link) %>%
  bind_rows(adresy_w_bazce_gumtree %>% select(-opis, -link)) %>%
  unique() -> inputData

save(inputData, file = "dane/inputData.rda")