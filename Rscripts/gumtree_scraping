# Załadowanie środowiska --------------------------------------------------
library(rvest)
library(stringi)
library(stringr)
library(RSQLite)

aktualne_oferty <- function(link) {
  linki<-read_html(link) %>%
    html_nodes('.href-link') %>%
    html_attr('href') %>%
    paste0('http://www.gumtree.pl', .) 
  #usunięcie trzech pierwszych ofert, które są sponsorowane i z każdym odświeżeniem ulegają zmianie
  linki<-linki[-c(1,2,3)]
  return(linki)
}
scrapuj <- function (x) {
  read_html(x) -> web
  
  web %>%
    html_nodes('.clearfix .amount') %>%
    html_text() %>%
    str_replace_all("[^0-9]","")-> cena
  if(length(cena)==0) cena<-""
  
  web %>%
    html_nodes("li:nth-child(8) .value") %>%
    html_text() %>%
    str_replace_all("[^0-9]","") -> wielkosc
  if(length(wielkosc)==0) wielkosc<-""
  
  web %>%
    html_nodes('.telephone') %>%
    html_text() %>%
    stri_extract_all_words() %>%
    unlist() -> telefon
  if(length(telefon)==0) telefon<-""
  
  web %>%
    html_nodes('.vip-details .description') %>%
    html_text() %>%
    stri_extract_all_words() %>%
    unlist() %>%
    paste(collapse = " ") -> opis
  if(length(opis)==0) opis<-""
  #usunięcie apostrof
  opis<-gsub("'",'',opis)
  
  web %>%
    html_nodes('.main img') %>%
    html_attr('src') -> link_do_zdj
  if(length(link_do_zdj)==0) link_do_zdj<-""
  
  web %>%
    html_nodes("li:nth-child(1) .value") %>%
    html_text() %>%
    str_replace_all("[\n\t]","") -> data_dodania
  if(length(data_dodania)==0) data_dodania<-""
  data_dodania<-as.Date(data_dodania,format="%d/%m/%Y")
  
  return(list(cena = cena, wielkosc = wielkosc, telefon = telefon, opis = opis, data_dodania = data_dodania))
}

if (file.exists("czas_dojazdu.db")==F){
  gumtree_warszawa_pokoje <- data.frame(cena = "", wielkosc = "", telefon = "", opis = "", data_dodania="", link="" ,                             
                                        stringsAsFactors = FALSE)

  polaczenie <- dbConnect( dbDriver( "SQLite" ), "czas_dojazdu.db" )
  
  dbWriteTable(polaczenie, name = "gumtree_warszawa_pokoje", gumtree_warszawa_pokoje, overwrite = TRUE, row.names = FALSE)  
}

polaczenie <- dbConnect( dbDriver( "SQLite" ), "czas_dojazdu.db" )

# Zmienne startowe --------------------------------------------------------

liczba_stron<-5

# Scrapowanie -------------------------------------------------------------

linki <- paste('http://www.gumtree.pl/s-pokoje-do-wynajecia/warszawa/v1c9000l3200008p',1:liczba_stron,sep="")
adresy<-c(sapply(linki,aktualne_oferty))

adresydb<- as.vector(as.matrix(dbGetQuery(polaczenie,"select link from gumtree_warszawa_pokoje")))
adresy<-adresy[!(adresy %in% adresydb)]

dane<-lapply(adresy,scrapuj)

# Wgrywanie danych do DB --------------------------------------------------
zap<-c()
for (i in seq_along(dane)){
  zap[i]<-paste("('",dane[[i]]$cena,"','",dane[[i]]$wielkosc,"','",dane[[i]]$telefon,"','",
                dane[[i]]$opis,"','",dane[[i]]$data_dodania,"','",adresy[i],"')",collapse="",sep="")
}

insert<-paste0("INSERT INTO gumtree_warszawa_pokoje(cena,wielkosc,telefon,opis,data_dodania,link)
             VALUES ",paste(zap,collapse=","))
rm(zap)

dbGetQuery(polaczenie,insert)
