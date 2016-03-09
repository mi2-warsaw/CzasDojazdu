inputData %>%
  filter(!is.na(wielkosc)) %>% 
  mutate(dzielnica = ifelse(dzielnica == "Praga Północ",
                            "Praga-Północ",
                            dzielnica)) %>%
  mutate(dzielnica = ifelse(dzielnica == "Praga Południe",
                            "Praga-Południe",
                            dzielnica)) %>%
  filter(wielkosc != "") %>%
  mutate(wielkosc = as.numeric(wielkosc)) %>%
  group_by(dzielnica) %>%
  summarise(min_wielkosc = min(wielkosc),
            max_wielkosc = max(wielkosc),
            med_wielkosc = median(wielkosc),
            count = n()) %>%
  ungroup() %>%
  mutate(med_wielkosc_cut = cut(med_wielkosc,
                           round(quantile(med_wielkosc,
                                          probs = seq(0,1,0.25)),-1),
                           include.lowest = TRUE,
                           dig.lab = 4)
  ) -> przedzialy_wielkosciowe_dzielnic

library(ggthemes)
dane.df %>%
  left_join(przedzialy_wielkosciowe_dzielnic,
            by= "dzielnica") %>% 
  ggplot(aes(long, lat)) + 
  aes(long,lat,group=group,fill=med_wielkosc_cut) + 
  geom_polygon(aes(group=group)) +
  geom_path(color="grey") +
  coord_equal() +
  #scale_fill_manual(values=cols, name="Dzielnica") +
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




library(RTCGA)
