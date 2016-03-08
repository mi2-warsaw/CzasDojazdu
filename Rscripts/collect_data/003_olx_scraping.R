
source('Rscripts/inne/ulice/adres_z_opisu.R')
slownik <- data.table::fread('dicts/warszawskie_ulice.txt', 
                             encoding = "UTF-8", data.table = FALSE) %>% unlist
names(slownik) <- NULL

aktualne_oferty <- function(link) {
  linki<-read_html(link) %>%
    html_nodes('.detailsLink') %>%
    html_attr('href') %>% unique()
  return(linki)
}

scrapuj <- function (x, slownik, miasto = "Warszawa") {
  read_html(x) -> web
  
  # dzielnica
  web %>%
    html_nodes('.c2b') %>% 
    html_text() %>%
    str_replace_all("Warszawa, Mazowieckie, " , "") %>% 
    str_replace_all("[\r\n]" , "") %>% 
    stri_trim() -> dzielnica
  
  # cena
  web %>%
    html_nodes('.not-arranged') %>%
    html_text() %>%
    str_replace_all("[^0-9]","")-> cena
  if(length(cena)==0) cena<-""
  cena<-cena[1]
  
#   # telefon
#   html_nodes(web, "li.rel") %>%      
#     html_attrs() %>%                 
#     flatten_chr() %>%                
#     keep(~grepl("rel \\{", .x)) %>%  
#     str_extract("(\\{.*\\})") %>%    
#     unique() %>%                     
#     map_df(function(x) {
#       
#       path <- str_match(x, "'path':'([[:alnum:]]+)'")[,2]                  
#       id <- str_match(x, "'id':'([[:alnum:]]+)'")[,2]                      
#       
#       ajax <- sprintf("http://olx.pl/ajax/misc/contact/%s/%s/", path, id)  
#       value <- content(GET(ajax))$value                                    
#       
#       data.frame(path=path, id=id, value=value, stringsAsFactors=FALSE)    
#       
#     }) -> telefon 
#   if(length(telefon)==0) { 
#     telefon<-"" } else {
#       telefon<-as.character(telefon[which(telefon[,1]=="phone"),3])
#       telefon<-str_replace_all(telefon,"[^0-9 ]","")
#       telefon<-as.character(substr(telefon,1,12))
#     }
  
  # opis
  web %>%
    html_nodes('.descriptioncontent div p') %>%
    html_text() %>%
    str_replace_all("[\r\n]" , "") %>%
    stri_trim()-> opis
  if(length(opis)==0) {
    opis<-""
  } else {
    opis<-opis[1]
    #usunięcie apostrof i cudzysłów
    opis<-gsub("'",'',opis)
    opis<-gsub("\"",'',opis)
    opis<-gsub("\\(|\\)",'',opis)
  }
  

  # adres
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
  
  
  # content
  content <- paste(sep = "<br/>",
                   paste0('<b><a href="',x,'">',adres,"</a></b>"),
                   paste0("Cena: ", cena))
  
  # wspolrzedne
  ggmap::geocode(paste(adres, miasto)) -> wspolrzedne

  # link do zdjęcia
  web %>%
    html_nodes('.inlblk .bigImage') %>%
    html_attr('src') -> link_do_zdj
  if(length(link_do_zdj)==0) link_do_zdj<-""
  
  # data dodania ogłoszenia
  web %>%
    html_nodes(".brlefte5") %>%
    html_text() %>%
    str_replace_all("[\n\t]","") -> data_dodania
  if(length(data_dodania)==0) data_dodania<-""
  p1<-str_extract(data_dodania[1],".*,")
  p2<-str_extract(p1,",.*")
  data_dodania<-str_replace_all(p2,"[,]","")
  
  data_dodania<-str_replace_all(data_dodania[1],"stycznia","styczeń")
  data_dodania<-str_replace_all(data_dodania[1],"lutego","luty")
  data_dodania<-str_replace_all(data_dodania[1],"marca","marzec")
  data_dodania<-str_replace_all(data_dodania[1],"kwietnia","kwiecień")
  data_dodania<-str_replace_all(data_dodania[1],"maja","maj")
  data_dodania<-str_replace_all(data_dodania[1],"czerwca","czerwiec")
  data_dodania<-str_replace_all(data_dodania[1],"lipca","lipiec")
  data_dodania<-str_replace_all(data_dodania[1],"sierpnia","sierpień")
  data_dodania<-str_replace_all(data_dodania[1],"września","wrzesień")
  data_dodania<-str_replace_all(data_dodania[1],"października","październik")
  data_dodania<-str_replace_all(data_dodania[1],"listopada","listopad")
  data_dodania<-str_replace_all(data_dodania[1],"grudnia","grudzień")
  
  data_dodania<-as.Date(data_dodania,format=" %d %B %Y")
  
  
  return(list(cena = cena, #telefon = telefon, 
              opis = opis, adres=adres, link=x,
              content=content, lon=wspolrzedne$lon, lat=wspolrzedne$lat,
              link_do_zdj=link_do_zdj, dzielnica=dzielnica, 
              data_dodania = data_dodania))
}

tworz_olx_pokoje <- function(polaczenie){
  olx_warszawa_pokoje <- data.frame(cena = "", #telefon = "", 
                                    opis = "",adres="", link="", content="",lon="",lat="",
                                    link_do_zdj="", dzielnica="", 
                                    data_dodania="", link="" ,  stringsAsFactors = FALSE)
  
  #polaczenie <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )
  
  dbWriteTable(polaczenie, name = "olx_warszawa_pokoje",
               olx_warszawa_pokoje, overwrite = TRUE, row.names = FALSE)  
}

polaczenie <- dbConnect( dbDriver( "SQLite" ), "dane/czas_dojazdu.db" )
if (!("olx_warszawa_pokoje" %in% dbListTables(polaczenie))){
  tworz_olx_pokoje(polaczenie)
}

# Zmienne startowe --------------------------------------------------------

liczba_stron<-2

# Scrapowanie -------------------------------------------------------------

linki <- paste("http://olx.pl/nieruchomosci/stancje-pokoje/warszawa/?page=",1:liczba_stron,sep="")
adresy<-sapply(linki,aktualne_oferty)
adresy<-unlist(adresy)
names(adresy) <- NULL

adresydb<- as.vector(as.matrix(dbGetQuery(polaczenie,"select link from olx_warszawa_pokoje")))
adresy<-adresy[!(adresy %in% adresydb)]

dane<-lapply(adresy,scrapuj, slownik = slownik)


# Wgrywanie danych do DB --------------------------------------------------
zap<-c()
for (i in seq_along(dane)){
  zap[i]<-paste("('",dane[[i]]$cena,"','",#dane[[i]]$telefon,"','",
                dane[[i]]$opis,"','",
                dane[[i]]$adres,"','",dane[[i]]$link,"','",dane[[i]]$content,"','",dane[[i]]$lon,"','",
                dane[[i]]$lat,"','",dane[[i]]$link_do_zdj,"','",dane[[i]]$dzielnica,"','",
                dane[[i]]$data_dodania,"')",collapse="",sep="")
}


insert<-paste0("INSERT INTO olx_warszawa_pokoje(cena,opis,
                  adres,link,content,lon,lat,link_do_zdj,dzielnica,data_dodania)
               VALUES ",paste(zap,collapse=","))

dbGetQuery(polaczenie,insert)

#df<-dbGetQuery(polaczenie,"select * from olx_warszawa_pokoje")

dbDisconnect(polaczenie)
