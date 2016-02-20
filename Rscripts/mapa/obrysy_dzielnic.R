library(dplyr)
library(rgdal)
library(maptools)
library(ggplot2)

# wczytujemy listę kodów TERYT
teryt <- read.csv("dicts/TERYT.csv", colClasses = "character")

# filtrujemy dzielnice Warszawy z zestawienia TERYT (oprócz samej Warszawy) - pierwsze 4 znaki kodu
terytWa <- teryt %>%
  filter(grepl("1465", TERYT) & TERYT != "1465011")

colnames(terytWa) <- c("dzielnica","id")

# pobieramy ze stron GUS odpowiedni plik (np. BREC)
# tu instrukcja jak dobrać się do danych (punkt 3): https://geo.stat.gov.pl/faq
# tu dane: https://geo.stat.gov.pl/imap/
# UWAGA! pliki są duże, np. SU_BREC_2014_REJ.shp = 263MB

# wczytujemy dane; library(rgdal)
jedn <- readOGR(dsn = "TWÓJ_PLIK", layer = 'SU_BREC_2014_REJ')

# podglądamy nazwy zmiennych w pliku *.shp
str(as.data.frame(jedn))

# do ramki danych; uwaga, spora: 75 milionów rekordów
jedn.df <- fortify(jedn, region = "GMINA")

# wybieramy interesujące nas dane obrysów (dzielnic Warszawy)
obrysy <- jedn.df %>%
  filter(grepl("1465", id))

# dociągamy nazwę dzielnicy
dane.df <- dplyr::left_join(obrysy, terytWa, by = "id")

# rysujemy obrysy
# np. w takich kolorach
cols = rainbow(18, s=.6, v=.7)[sample(1:18,18)]

# i gotowe!
ggplot(dane.df, aes(long, lat)) + 
  aes(long,lat,group=group,fill=dzielnica) + 
  geom_polygon(aes(group=group)) +
  geom_path(color="grey") +
  coord_equal() +
  scale_fill_manual(values=cols, name="Dzielnica") +
  theme_bw() +
  theme(axis.ticks = element_blank(), 
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.key = element_blank())
  
  
