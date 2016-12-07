source('Rscripts/inne/ulice/adres_z_opisu.R')
slownik <-
  fread(
    'dicts/warszawskie_ulice.txt', encoding = "UTF-8", data.table = FALSE
  ) %>%
  unlist() %>%
  unname()

aktualne_oferty <-
  function(link) {
    linki <-
      read_html(link) %>%
      html_nodes('.href-link') %>%
      html_attr('href') %>%
      paste0('http://www.gumtree.pl', .)
    
    # usunięcie trzech pierwszych ofert, które są sponsorowane i z każdym
    # odświeżeniem ulegają zmianie
    linki <- linki[-(1:3)]
    return(linki)
  }

scrapuj <-
  function (x, slownik, miasto = "Warszawa") {
    tryCatch({
      read_html(x, encoding = "UTF-8") -> web
      
      # cena
      web %>%
        html_nodes('.clearfix .amount') %>%
        html_text() %>%
        str_replace_all("[^0-9]","") -> cena
      if(length(cena) == 0) cena <- ""
      
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
      if(length(opis) == 0) opis <- ""
      # usunięcie apostrofu
      opis <- gsub("'",'',opis)
      tryCatch(
        {repair_encoding(opis) -> opis}, 
        error = function(e) {return(opis)}
      )
      
      # adres
      web %>%
        html_nodes('.address') %>%
        html_text() -> adres
      
      if(length(adres) == 0) {
        
        ulice(opis) -> poprawny_adres
        
        num_adres <- grepl("1|2|3|4|5|6|7|8|9|0", poprawny_adres)
        if (sum(num_adres) > 0) {
          poprawny_adres[num_adres] -> poprawny_adres
        }
        
        # z odmiany adresu zrobienie poprawnej nazwy ulicy
        if (length(poprawny_adres) > 0) {
          if (length(strsplit(poprawny_adres, " ")[[1]]) > 1) {
            numer_bloku <- tail(strsplit(poprawny_adres, " ")[[1]],1)
            grep(
              "1|2|3|4|5|6|7|8|9|0", numer_bloku, value = TRUE
            ) -> numer_bloku
          } else {
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
      if(length(link_do_zdj) == 0) link_do_zdj <- ""
      
      # wspolrzedne
      geocode(paste(adres, miasto)) -> wspolrzedne
      
      # atrybuty oferty
      c(".name", ".attribute .value") %>%
        lapply(
          function(css) {
            css %>%
              html_nodes(web, .) %>%
              html_text()
          }
        ) %>%
        setNames(c("keys", "values")) %>%
        as_data_frame() %>%
        spread(keys, values) %>%
        setNames(
          names(.) %>%
            tolower() %>%
            gsub("[[:punct:]]", "", .) %>%
            gsub("[[:space:]]", "_", .)
        ) %>%
        lapply(
          function(col) {
            col %>%
              trimws() %>%
              gsub(",[[:space:]]*", ", ", .)
          }
        ) %>%
        as_data_frame() %>%
        mutate(
          data_dodania = as.Date(data_dodania, format = "%d/%m/%Y") %>%
            as.character()
        ) -> atrybuty
      
      if ("dostępny" %in% names(atrybuty)) {
        atrybuty <-
          atrybuty %>%
          mutate(
            dostępny = as.Date(dostępny, format = "%d/%m/%Y") %>%
              as.character()
          )
      }
      
      content <-
        paste(
          sep = "<br/>",
          paste0('<b><a href="', x, '">', adres, "</a></b>"),
          paste0("Cena: ", cena),
          paste0("Wielkość: ", atrybuty$wielkość_m2)
        )
      
      lista <-
        list(
          link = x,
          cena = cena,
          # telefon = telefon,
          opis = opis,
          adres = adres,
          link_do_zdj = link_do_zdj,
          lon = wspolrzedne$lon,
          lat = wspolrzedne$lat,
          data_dodania = atrybuty$data_dodania,
          dostepny = atrybuty$dostępny,
          do_wynajecia_przez = atrybuty$do_wynajęcia_przez,
          liczba_pokoi = atrybuty$liczba_pokoi,
          dzielnica = atrybuty$lokalizacja,
          palacy = atrybuty$palący,
          parking = atrybuty$parking,
          przyjazne_zwierzakom = atrybuty$przyjazne_zwierzakom,
          rodzaj_nieruchomosci = atrybuty$rodzaj_nieruchomości,
          wielkosc = atrybuty$wielkość_m2,
          liczba_lazienek = atrybuty$liczba_łazienek,
          content = content
        ) %>%
        lapply(
          function(x) {
            ifelse(is.null(x), "", x)
          }
        )
      
      return(lista)
    }, error = function(e) {
      return(
        list(
          link = x,
          cena = NA,
          # telefon = NA,
          opis = NA,
          adres = NA,
          link_do_zdj = NA,
          lon = NA,
          lat = NA,
          data_dodania = NA,
          dostepny = NA,
          do_wynajecia_przez = NA,
          liczba_pokoi = NA,
          dzielnica = NA,
          palacy = NA,
          parking = NA,
          przyjazne_zwierzakom = NA,
          rodzaj_nieruchomosci = NA,
          wielkosc = NA,
          liczba_lazienek = NA,
          content = NA
        )
      )
    })
  }

tworz_gumtree_mieszkania <-
  function(polaczenie) {
    gumtree_warszawa_mieszkania <-
      data.frame(
        link = "",
        cena = "",
        # telefon = "",
        opis = "",
        adres = "",
        link_do_zdj = "",
        lon = "",
        lat = "",
        data_dodania = "",
        dostepny = "",
        do_wynajecia_przez = "",
        liczba_pokoi = "",
        dzielnica = "",
        palacy = "",
        parking = "",
        przyjazne_zwierzakom = "",
        rodzaj_nieruchomosci = "",
        wielkosc = "",
        liczba_lazienek = "",
        content = "",
        stringsAsFactors = FALSE
      )
    
    # polaczenie <- dbConnect(dbDriver("SQLite"), "dane/czas_dojazdu.db")
    
    dbWriteTable(
      polaczenie, "gumtree_warszawa_mieszkania_02",
      gumtree_warszawa_mieszkania, overwrite = TRUE, row.names = FALSE
    )
  }

# if (!file.exists("dane/czas_dojazdu.db")){
#   tworz_gumtree_mieszkania()
# }

polaczenie <- dbConnect(dbDriver("SQLite"), "dane/czas_dojazdu.db")
if (!("gumtree_warszawa_mieszkania_02" %in% dbListTables(polaczenie))) {
  tworz_gumtree_mieszkania(polaczenie)
}

# Zmienne startowe --------------------------------------------------------

liczba_stron <- 5

# Scrapowanie -------------------------------------------------------------

linki <- paste0(
  'http://www.gumtree.pl/s-mieszkania-i-domy-do-wynajecia/warszawa/v1c9008l3200008p',
  1:liczba_stron
)

adresy <- linki %>% pbsapply(aktualne_oferty) %>% c()

adresydb <-
  dbGetQuery(polaczenie, "SELECT link FROM gumtree_warszawa_mieszkania_02") %>%
  .$link

adresy <- adresy[!(adresy %in% adresydb)]

if (length(adresy) > 0) {
  dane <- adresy %>% pblapply(scrapuj, slownik = slownik)
  
  keys <- c("szukam", "poszukuj[eę]")
  fake <- c()
  for (i in seq_along(dane)) {
    opis <- dane[[i]]$opis
    ifelse(
      grepl(paste(keys, collapse="|"), opis, ignore.case = TRUE),
      fake[length(fake)+1] <- i,
      next
    )
  }
  dane[fake] <- NULL
  
  # for( i in 1:length(adresy)){
  #   scrapuj(x = adresy[i], slownik = slownik)
  # }
  
  # Wgrywanie danych do DB --------------------------------------------------
  zap <- c()
  for (i in seq_along(dane)) {
    zap[i] <-
      paste(
        "('",
        dane[[i]]$link, "','",
        dane[[i]]$cena, "','",
        # dane[[i]]$telefon, "','",
        dane[[i]]$opis, "','",
        dane[[i]]$adres, "','",
        dane[[i]]$link_do_zdj, "','",
        dane[[i]]$lon, "','",
        dane[[i]]$lat, "','",
        dane[[i]]$data_dodania, "','",
        dane[[i]]$dostepny, "','",
        dane[[i]]$do_wynajecia_przez, "','",
        dane[[i]]$liczba_pokoi, "','",
        dane[[i]]$dzielnica, "','",
        dane[[i]]$palacy, "','",
        dane[[i]]$parking, "','",
        dane[[i]]$przyjazne_zwierzakom, "','",
        dane[[i]]$rodzaj_nieruchomosci, "','",
        dane[[i]]$wielkosc, "','",
        dane[[i]]$liczba_lazienek, "','",
        dane[[i]]$content,
        "')",
        collapse = "",
        sep = ""
      )
  }
  
  insert <-
    paste0(
      "INSERT INTO gumtree_warszawa_mieszkania_02 (",
      dane[[1]] %>% names() %>% paste0(collapse = ","),
      ") VALUES ",
      paste(zap, collapse = ",")
    )
  
  dbGetQuery(polaczenie, insert)
  
  # mala obczajka jakie sa potencjalne adresy
  # dbGetQuery(polaczenie, "SELECT * FROM gumtree_warszawa_mieszkania_02") -> adresy_w_bazce
  # repair_encoding(adresy_w_bazce$adres, from = "UTF-8")
}
dbDisconnect(polaczenie)