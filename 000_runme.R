# scrapuj dane i aktualizuj baze danych
source('Rscripts/001_pakiety.R', echo = TRUE)
source('Rscripts/collect_data/0020_gumtree_scraping_pokoje.R', echo = TRUE)
source('Rscripts/collect_data/0021_gumtree_scraping_mieszkania.R', echo = TRUE)
source('Rscripts/collect_data/0030_olx_scraping.R', echo = TRUE)
# aktualizuj dane na ktorych pracuje aplikacja
#source('Rscripts/collect_data/004_dane_pod_aplikacje.R')
