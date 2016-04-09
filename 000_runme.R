# scrapuj dane i aktualizuj baze danych
source('Rscripts/001_pakiety.R')
source('Rscripts/collect_data/002_gumtree_scraping.R')
source('Rscripts/collect_data/003_olx_scraping.R')
# aktualizuj dane na ktorych pracuje aplikacja
source('Rscripts/collect_data/004_dane_pod_aplikacje.R')