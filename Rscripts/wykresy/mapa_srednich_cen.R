library(ggthemes)
library(dplyr)
library(ggplot2)
library(tidyr)
library(RSQLite)
load("dane/dane_df.rda")


conn <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )
dbGetQuery(conn, 'select cena, adres, dzielnica,  content, lon, lat, data_dodania, link
            from gumtree_warszawa_pokoje 
            where cena <> "" and adres <> "" and dzielnica <> "" 
            and content <> "" and lon <> "" and lat <> "" and data_dodania <> "" ') -> dane

dbDisconnect(conn)

dane %>%
   filter(cena != "NA",
          cena != "") %>% 
   mutate(cena = as.numeric(as.character(cena)),
          data_dodania = as.Date(data_dodania),
          lon = as.numeric(as.character(lon)),
          lat = as.numeric(as.character(lat)),
          link = as.character(link)) %>%
   filter(cena > 200,
          cena < 5000,
          nchar(adres) > 2,
          lat <= 52.368653,
          lat >= 52.098673,
          lon <= 21.282646,
          lon >= 20.851555) %>%
   group_by(adres) %>%
   top_n(1, -cena) %>%
   top_n(1, link) %>%
   ungroup %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Północ", "Praga-Północ", dzielnica)) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Południe", "Praga-Południe", dzielnica)) %>%
  group_by(dzielnica) %>%
  summarise(min_cena = min(cena, na.rm = TRUE),
            max_cena = max(cena, na.rm = TRUE),
            sr_cena = mean(cena, na.rm = TRUE),
            count = n()) %>%
  ungroup() -> przed_pocieciem
przed_pocieciem %>%
  mutate(sr_cena_cut = cut(sr_cena,
                           round(quantile(przed_pocieciem$sr_cena,
                                          probs = seq(0,1,0.25)),-1),
                           include.lowest = TRUE,
                           dig.lab = 4)) -> przedzialy_cenowe
# przez zaokraglenia najnizsza wartosc wypada
przedzialy_cenowe[is.na(unlist(przedzialy_cenowe[, 6])), 6] <- levels(unique(unlist(przedzialy_cenowe[,6])))[1]

# Rysowanie mapy ----------------------------------------------------------

# współrzędne dla umiejscowienia etykiet (nazw dzielnic)
etykieta_pozycja <- aggregate(cbind(long, lat) ~ dzielnica, 
                              data = dane.df, FUN = function(x) mean(range(x)))
colnames(etykieta_pozycja) <- c("dzielnica", "long2", "lat2")

dane2 <- przedzialy_cenowe %>%
  left_join(etykieta_pozycja, by = "dzielnica") %>%
  mutate(etykieta = paste0(dzielnica, "\n", "(", round(sr_cena,-1), ")"))

dane2$etykieta <- gsub("-", "-\n", dane2$etykieta)
dane2$etykieta_cena <- gsub(",", " - ", dane2$sr_cena_cut)
dane2$etykieta_cena <- gsub("\\]", "", dane2$etykieta_cena)
dane2$etykieta_cena <- gsub("\\(", "", dane2$etykieta_cena)
dane2$etykieta_cena <- gsub("\\[[0-9]+ -", "do", dane2$etykieta_cena)

# ustawienie kolejności poziomów czynnika
dane2$etykieta_cena <- factor(dane2$etykieta_cena, levels = dane2$etykieta_cena[order(dane2$sr_cena_cut)])


dane.df %>%
  left_join(dane2, by = "dzielnica")  -> dane2plot
# 
# etykieta_pozycja %>%
#   left_join(dane2plot, by = "dzielnica") %>% head
#   select(dzielnica, long2, lat2, etykieta) %>% 
#   unique -> dane_etykiety

dane2plot %>%
  ggplot(aes(long, lat, group = group, fill = etykieta_cena, label=etykieta)) + 
  geom_polygon(aes(group = group)) +
  geom_path(color = "grey") +
  coord_equal() +
  theme_bw() +
  scale_fill_tableau(name="Przedziały cen w zł") +
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.key = element_blank(),
        legend.position="top") +
  ggtitle("Średnie ceny wynajmu mieszkań w dzielnicach Warszawy") +
  annotate("text", x = dane2plot$long2, y = dane2plot$lat2,
            label = dane2plot$etykieta, size = 4) ->  mapa_wykres

save(mapa_wykres, file = "mapa_wykres.rda")


