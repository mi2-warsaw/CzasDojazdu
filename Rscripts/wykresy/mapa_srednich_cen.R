library(ggthemes)
library(dplyr)
library(ggplot2)
library(tidyr)

inputData %>%
  filter(cena != "") %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga PÃ³Å‚noc",
                            "Praga-PÃ³Å‚noc",
                            dzielnica)) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga PoÅ‚udnie",
                            "Praga-PoÅ‚udnie",
                            dzielnica)) %>%
  mutate(cena = as.numeric(cena)) %>%
  group_by(dzielnica) %>%
  summarise(min_cena = min(cena),
            max_cena = max(cena),
            sr_cena = mean(cena),
            count = n()) %>%
  ungroup() %>%
  mutate(sr_cena_cut = cut(sr_cena,
                           round(quantile(sr_cena,
                                    probs = seq(0,1,0.25)),-1),
                           include.lowest = TRUE,
                           dig.lab = 4)
         ) -> przedzialy_cenowe

przedzialy_cenowe$dzielnica <- as.factor(przedzialy_cenowe$dzielnica)

etykieta_pozycja <- aggregate(cbind(long, lat) ~ dzielnica, 
                              data = dane.df, FUN = function(x) mean(range(x)))
colnames(etykieta_pozycja) <- c("dzielnica", "long2", "lat2")

przedzialy_cenowe <- przedzialy_cenowe %>%
  left_join(etykieta_pozycja, by = "dzielnica") %>%
  mutate(etykieta = paste0(dzielnica, "\n", "(", round(sr_cena,-1), ")"))

przedzialy_cenowe$etykieta <- gsub("-", "-\n", przedzialy_cenowe$etykieta)

przedzialy_cenowe$etykieta_cena <- gsub(",", " - ", przedzialy_cenowe$sr_cena_cut)
przedzialy_cenowe$etykieta_cena <- gsub("\\]", "", przedzialy_cenowe$etykieta_cena)
przedzialy_cenowe$etykieta_cena <- gsub("\\(", "", przedzialy_cenowe$etykieta_cena)
przedzialy_cenowe$etykieta_cena <- gsub("\\[[0-9]+ -", "do", przedzialy_cenowe$etykieta_cena)


# ustawienie kolejnoœci poziomów czynnika
przedzialy_cenowe$etykieta_cena <- factor(przedzialy_cenowe$etykieta_cena, 
                                          levels = przedzialy_cenowe$etykieta_cena[order(przedzialy_cenowe$sr_cena_cut)])


dane.df$dzielnica <- as.factor(dane.df$dzielnica)


dane.df %>%
  left_join(przedzialy_cenowe,
            by = "dzielnica") %>% 
  ggplot(aes(long, lat)) + 
  aes(long, lat, group = group, fill = etykieta_cena) + 
  geom_polygon(aes(group=group)) +
  geom_path(color = "grey") +
  coord_equal() +
  theme_bw() +
  scale_fill_tableau(name="Przedzia³y cen") +
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.key = element_blank()) +
  geom_text(aes(long2, lat2, label = etykieta), size = 4) +
  ggtitle("Œrednie ceny wynajmu mieszkañ w dzielnicach Warszawy")

