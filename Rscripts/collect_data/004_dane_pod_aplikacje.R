#
polaczenie <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )

data_od <- Sys.Date() -3

dbGetQuery(polaczenie,
           paste0("select * from gumtree_warszawa_pokoje",
                  " where data_dodania >=", data_od)
           ) -> adresy_w_bazce_gumtree

dbGetQuery(polaczenie,
           paste0("select * from olx_warszawa_pokoje",
                  " where data_dodania >=", data_od)
           ) -> adresy_w_bazce_olx

adresy_w_bazce_olx %>% select(-opis, -link) %>%
  bind_rows(adresy_w_bazce_gumtree %>% select(-opis, -link)) %>%
  unique() -> inputData

save(inputData, file = "dane/inputData.rda")


  