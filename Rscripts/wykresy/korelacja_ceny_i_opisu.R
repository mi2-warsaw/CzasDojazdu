library(stringi)
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

dbDisconnect(polaczenie)

adresy_w_bazce_olx %>%
  bind_rows(adresy_w_bazce_gumtree)  %>%
  unique()  %>% select(cena, opis) %>%
  mutate(dlugosc_opisu = stri_count_words(opis)) %>%
  filter(cena != "") %>%
  mutate(cena = as.numeric(cena)) %>%
  filter(cena > 100) %>%
  mutate(dlugosc_opisu_cut = cut(dlugosc_opisu,
                                round(quantile(dlugosc_opisu,
                                               probs = seq(0,1,0.25)),-1),
                                include.lowest = TRUE,
                                dig.lab = 4))-> inputData_opis

theme_RTCGA <- function(base_size = 11, base_family = "", ...){
  list(theme_pander(gm = TRUE, gM = TRUE, ...) %+replace%
         theme(panel.grid = element_line(), 
               panel.grid.major = element_line(colour = "grey90", size = 0.2),
               panel.grid.minor = element_line(colour = "grey98", size = 0.5),
               legend.position = "top"), 
       scale_colour_tableau(),
       scale_fill_tableau())
}

inputData_opis %>%
  filter(cena <=2000) %>%
  ggplot(aes(cena, dlugosc_opisu)) +
  geom_point(aes(col = dlugosc_opisu_cut)) + theme_RTCGA() +
  geom_smooth(method="lm")

