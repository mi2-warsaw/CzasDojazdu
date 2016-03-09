inputData %>%
  filter(cena != "") %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Północ",
                            "Praga-Północ",
                            dzielnica)) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Południe",
                            "Praga-Południe",
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
         ) -> przedzialy_cenowe_dzielnic

library(ggthemes)
dane.df %>%
  left_join(przedzialy_cenowe_dzielnic,
            by= "dzielnica") %>% 
  ggplot(aes(long, lat)) + 
  aes(long,lat,group=group,fill=sr_cena_cut) + 
  geom_polygon(aes(group=group)) +
  geom_path(color="grey") +
  coord_equal() +
  scale_fill_manual(values=cols, name="Dzielnica") +
  theme_bw() +
  scale_fill_tableau() +
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.key = element_blank()) 
  + tytul
  + etykieta ze srednia cena wewnatrz dzielnicy
  + + i z njej nazwa

  

  
library(RTCGA)
