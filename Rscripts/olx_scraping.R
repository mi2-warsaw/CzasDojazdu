# Załadowanie środowiska --------------------------------------------------
library(rvest)
library(stringi)
library(stringr)
library(RSQLite)
library(RSelenium)
library(httr)
library(purrr)

aktualne_oferty <- function(link) {
  linki<-read_html(link) %>%
    html_nodes('.detailsLink') %>%
    html_attr('href') %>% unique()
  return(linki)
}

scrapuj <- function (x) {
  read_html(x) -> web
  
  web %>%
    html_nodes('.not-arranged') %>%
    html_text() %>%
    str_replace_all("[^0-9]","")-> cena
  if(length(cena)==0) cena<-""
  cena<-cena[1]
  
  html_nodes(web, "li.rel") %>%      
    html_attrs() %>%                 
    flatten_chr() %>%                
    keep(~grepl("rel \\{", .x)) %>%  
    str_extract("(\\{.*\\})") %>%    
    unique() %>%                     
    map_df(function(x) {
      
      path <- str_match(x, "'path':'([[:alnum:]]+)'")[,2]                  
      id <- str_match(x, "'id':'([[:alnum:]]+)'")[,2]                      
      
      ajax <- sprintf("http://olx.pl/ajax/misc/contact/%s/%s/", path, id)  
      value <- content(GET(ajax))$value                                    
      
      data.frame(path=path, id=id, value=value, stringsAsFactors=FALSE)    
      
    }) -> telefon 
  if(length(telefon)==0) { 
    telefon<-"" } else {
     telefon<-as.character(telefon[which(telefon[,1]=="phone"),3])
     telefon<-str_replace_all(telefon,"[^0-9 ]","")
     telefon<-as.character(substr(telefon,1,12))
    }
  web %>%
    html_nodes('.descriptioncontent div p') %>%
    html_text() %>%
    str_replace_all("[\r\n]" , "") -> opis
  if(length(opis)==0) opis<-""
  #usunięcie apostrof i cudzysłów
  opis<-gsub("'",'',opis)
  opis<-gsub("\"",'',opis)
  
  web %>%
    html_nodes('.inlblk .bigImage') %>%
    html_attr('src') -> link_do_zdj
  if(length(link_do_zdj)==0) link_do_zdj<-""
  
  
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
  
  
  return(list(cena = cena, telefon = telefon, opis = opis, link_do_zdj=link_do_zdj, data_dodania = data_dodania))
}

if (file.exists("czas_dojazdu.db")==F){
  olx_warszawa_pokoje <- data.frame(cena = "", telefon = "", opis = "", link_do_zdj="",
                                    data_dodania="", link="" ,  stringsAsFactors = FALSE)
  
  polaczenie <- dbConnect( dbDriver( "SQLite" ), "czas_dojazdu.db" )
  
  dbWriteTable(polaczenie, name = "olx_warszawa_pokoje", olx_warszawa_pokoje, overwrite = TRUE, row.names = FALSE)  
}

polaczenie <- dbConnect( dbDriver( "SQLite" ), "czas_dojazdu.db" )


# Zmienne startowe --------------------------------------------------------

liczba_stron<-2

# Scrapowanie -------------------------------------------------------------

linki <- paste("http://olx.pl/nieruchomosci/stancje-pokoje/warszawa/?page=",1:liczba_stron,sep="")
adresy<-sapply(linki,aktualne_oferty)
adresy<-flatten_chr(adresy)


adresydb<- as.vector(as.matrix(dbGetQuery(polaczenie,"select link from olx_warszawa_pokoje")))
adresy<-adresy[!(adresy %in% adresydb)]

dane<-lapply(adresy,scrapuj)


# Wgrywanie danych do DB --------------------------------------------------
zap<-c()
for (i in seq_along(dane)){
  zap[i]<-paste("('",dane[[i]]$cena,"','",dane[[i]]$telefon,"','",dane[[i]]$opis,"','",
                dane[[i]]$link_do_zdj,"','",dane[[i]]$data_dodania,"','",adresy[i],"')",collapse="",sep="")
}

insert<-paste0("INSERT INTO olx_warszawa_pokoje(cena,telefon,opis,link_do_zdj,data_dodania,link)
             VALUES ",paste(zap,collapse=","))
rm(zap)

dbGetQuery(polaczenie,insert)

df<-dbGetQuery(polaczenie,"select * from olx_warszawa_pokoje")




