library(ggthemes)
library(dplyr)
library(ggplot2)
library(tidyr)

load("dane/dane_df.rda")

# przypisanie dzielnic do przedziałów cen wynajmu
inputData$cena <- as.numeric(inputData$cena)
inputData %>%
  filter(cena != "") %>%
  filter(cena >= quantile(cena, probs = 0.25) &
           cena <= quantile(cena, probs = 0.95)) %>%
  # filter(!cena %in% boxplot.stats(cena)$out) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Północ", "Praga-Północ", dzielnica)) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Południe", "Praga-Południe", dzielnica)) %>%
  mutate(cena = as.numeric(cena)) %>%
  group_by(dzielnica) %>%
  summarise(min_cena = min(cena),
            max_cena = max(cena),
            sr_cena = mean(cena),
            count = n()) %>%
  ungroup() %>%
  mutate(sr_cena_cut = cut(sr_cena,
                           round(quantile(sr_cena, probs = seq(0,1,0.25)),-1),
                           include.lowest = TRUE,
                           dig.lab = 4)) %>%
  filter(dzielnica %in% unique(dane.df$dzielnica)) -> przedzialy_cenowe

# Rysowanie mapy ----------------------------------------------------------

# współrzędne dla umiejscowienia etykiet (nazw dzielnic)
etykieta_pozycja <- aggregate(cbind(long, lat) ~ dzielnica, 
                              data = dane.df, FUN = function(x) mean(range(x)))
colnames(etykieta_pozycja) <- c("dzielnica", "long2", "lat2")

dane <- przedzialy_cenowe %>%
  left_join(etykieta_pozycja, by = "dzielnica") %>%
  mutate(etykieta = paste0(dzielnica, "\n", "(", round(sr_cena,-1), ")"))

dane$etykieta <- gsub("-", "-\n", dane$etykieta)
dane$etykieta_cena <- gsub(",", " - ", dane$sr_cena_cut)
dane$etykieta_cena <- gsub("\\]", "", dane$etykieta_cena)
dane$etykieta_cena <- gsub("\\(", "", dane$etykieta_cena)
dane$etykieta_cena <- gsub("\\[[0-9]+ -", "do", dane$etykieta_cena)

# ustawienie kolejności poziomów czynnika
dane$etykieta_cena <- factor(dane$etykieta_cena, levels = dane$etykieta_cena[order(dane$sr_cena_cut)])

dane.df %>%
  left_join(dane, by = "dzielnica")  %>%
  ggplot(aes(long, lat, group = group, fill = etykieta_cena)) + 
  geom_polygon(aes(group = group)) +
  geom_path(color = "grey") +
  coord_equal() +
  theme_bw() +
  scale_fill_tableau(name="Przedziały cen") +
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.key = element_blank()) +
  ggtitle("Średnie ceny wynajmu mieszkań w dzielnicach Warszawy")
# + geom_text(data = dane, aes(long2, lat2, label = etykieta), size = 4)

