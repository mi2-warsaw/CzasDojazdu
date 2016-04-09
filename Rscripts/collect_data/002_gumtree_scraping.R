
source('Rscripts/inne/ulice/adres_z_opisu.R')
slownik <- data.table::fread('dicts/warszawskie_ulice.txt', 
                             encoding = "UTF-8", data.table = FALSE) %>% unlist
names(slownik) <- NULL

aktualne_oferty <- function(link) {
  linki<-read_html(link) %>%
    html_nodes('.href-link') %>%
    html_attr('href') %>%
    paste0('http://www.gumtree.pl', .) 
  #usunięcie trzech pierwszych ofert, które są sponsorowane i z każdym odświeżeniem ulegają zmianie
  linki<-linki[-c(1,2,3)]
  return(linki)
}
scrapuj <- function (x, slownik, miasto = "Warszawa") {
  
  read_html(x, encoding = "UTF-8") -> web
  
  # cena
  web %>%
    html_nodes('.clearfix .amount') %>%
    html_text() %>%
    str_replace_all("[^0-9]","")-> cena
  if(length(cena)==0) cena<-""
  
  # wielkosc
  web %>%
    html_nodes("li:nth-child(8) .value") %>%
    html_text() %>%
    str_replace_all("[^0-9]","") -> wielkosc
  if(length(wielkosc)==0) wielkosc<-""
  
  # # telefon
  # web %>%
  #   html_nodes('.telephone') %>%
  #   html_text() %>%
  #   stri_extract_all_words() %>%
  #   unlist() -> telefon
  # if(length(telefon)==0) telefon<-""
  
  # opis
  web %>%
    html_nodes('.vip-details .description') %>%
    html_text() %>%
    stri_extract_all_words() %>%
    unlist() %>%
    paste(collapse = " ") -> opis
  if(length(opis)==0) opis<-""
  #usunięcie apostrof
  opis<-gsub("'",'',opis)
  tryCatch({repair_encoding(opis) -> opis}, 
           error = function(e) {return(opis)})
  
  # adres
  web %>%
    html_nodes('.address') %>%
    html_text()-> adres
  
  if(length(adres)==0){
  
      ulice(opis) -> poprawny_adres
      
      if (sum(grepl("1|2|3|4|5|6|7|8|9|0", poprawny_adres)) > 0) {
        poprawny_adres[grepl("1|2|3|4|5|6|7|8|9|0", poprawny_adres)] -> poprawny_adres
      }
      # z odmainy adresu zrobienie poprawnej nazwy ulicy
      
      if (length(poprawny_adres) > 0) {
        if (length(strsplit(poprawny_adres, " ")[[1]]) > 1) {
          numer_bloku <- tail(strsplit(poprawny_adres, " ")[[1]],1)
          grep("1|2|3|4|5|6|7|8|9|0", numer_bloku, value = TRUE) -> numer_bloku
        } else{
          numer_bloku <- ""
        }
        poprawny_adres %>%
          stringdist(slownik) -> odleglosci
        which.min(odleglosci) -> index_adresu
        
        paste0(slownik[index_adresu], " ", numer_bloku) -> adres
      } else {
        adres <- ""
      }
  }

  # linki do zdjec
  web %>%
    html_nodes('.main img') %>%
    html_attr('src') -> link_do_zdj
  if(length(link_do_zdj)==0) link_do_zdj<-""
  
  # dzielnica
  web %>%
    html_nodes('.location a:nth-child(1)') %>% 
    html_text() -> dzielnica
  if(length(dzielnica)==0) dzielnica<-""
  
  # data dodania
  web %>%
    html_nodes("li:nth-child(1) .value") %>%
    html_text() %>%
    str_replace_all("[\n\t]","") -> data_dodania
  if(length(data_dodania)==0) data_dodania<-""
  data_dodania<-as.Date(data_dodania,format="%d/%m/%Y")
  
  content <- paste(sep = "<br/>",
                   paste0('<b><a href="',x,'">',adres,"</a></b>"),
                   paste0("Cena: ", cena),
                   paste0("Wielkość: ", wielkosc))
  
  ggmap::geocode(paste(adres, miasto)) -> wspolrzedne
  
  
  
  return(list(cena = cena, wielkosc = wielkosc, #telefon = telefon,
              opis = opis, link_do_zdj = link_do_zdj, adres = adres,
              dzielnica=dzielnica, data_dodania = data_dodania,
              link=x, content = content, lon = wspolrzedne$lon, lat = wspolrzedne$lat))
}


tworz_gumtree_pokoje <- function(polaczenie) {
  gumtree_warszawa_pokoje <- data.frame(cena = "", wielkosc = "", #telefon = "", 
                                        opis = "", link_do_zdj = "" , adres = "",
                                        dzielnica = "", data_dodania="", link="" ,
                                        content = "", lon = "", lat = "",
                                        stringsAsFactors = FALSE)
  # 
  # polaczenie <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )
  
  dbWriteTable(polaczenie, name = "gumtree_warszawa_pokoje",
               gumtree_warszawa_pokoje, overwrite = TRUE, row.names = FALSE)  
}

# 
# if (!file.exists("dane/czas_dojazdu.db")){
#   tworz_gumtree_pokoje()
# }

polaczenie <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )
if (!("gumtree_warszawa_pokoje" %in% dbListTables(polaczenie))){
  tworz_gumtree_pokoje(polaczenie)
}

# Zmienne startowe --------------------------------------------------------

liczba_stron<-5

# Scrapowanie -------------------------------------------------------------

linki <- paste('http://www.gumtree.pl/s-pokoje-do-wynajecia/warszawa/v1c9000l3200008p',1:liczba_stron,sep="")
adresy<-c(pbsapply(linki,aktualne_oferty))

adresydb<- as.vector(as.matrix(dbGetQuery(polaczenie,"select link from gumtree_warszawa_pokoje")))
adresy<-adresy[!(adresy %in% adresydb)]

dane<-pblapply(adresy,scrapuj, slownik = slownik)


# for( i in 1:length(adresy)){
#   scrapuj(x = adresy[i], slownik = slownik)
# }

# Wgrywanie danych do DB --------------------------------------------------
zap<-c()
for (i in seq_along(dane)){
  zap[i]<-paste("('",dane[[i]]$cena,"','",dane[[i]]$wielkosc,"','",#dane[[i]]$telefon,"','",
                dane[[i]]$opis,"','",dane[[i]]$link_do_zdj,"','",
                dane[[i]]$adres,"','", dane[[i]]$dzielnica, "','", dane[[i]]$data_dodania,"','",dane[[i]]$link,
                "','", dane[[i]]$content, "','", dane[[i]]$lon, "','", dane[[i]]$lat ,"')",collapse="",sep="")
}

insert<-paste0("INSERT INTO gumtree_warszawa_pokoje (cena,wielkosc,opis,link_do_zdj,adres,dzielnica,data_dodania,link, content, lon, lat) VALUES ",paste(zap,collapse=","))

dbGetQuery(polaczenie,insert)

# mala obczajka jakie sa potencjalnei adresy
# dbGetQuery(polaczenie, "select * from gumtree_warszawa_pokoje") -> adresy_w_bazce
# repair_encoding(adresy_w_bazce$adres, from = "UTF-8")

dbDisconnect(polaczenie)
