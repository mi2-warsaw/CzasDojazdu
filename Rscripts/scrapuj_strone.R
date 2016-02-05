


library(rvest)
library(stringi)

schakuj <- function (x = 'http://www.gumtree.pl/a-pokoje-do-wynajecia/krakow/pokoj-dwuosobowy-+-ul-armii-krajowej-8a/1001446303570910491288409') {
  read_html(x) -> web
  
  # tytul
  # link
  # liczba pokoi
  
  web %>%
  	html_nodes('.clearfix .amount') %>%
  	html_text() -> cena
  
  web %>%
  	html_nodes("li:nth-child(8) .value") %>%
  	html_text() -> wielkosc
  
  
  web %>%
  	html_nodes('.telephone') %>%
  	html_text() %>%
  	stri_extract_all_words() %>%
  	unlist() -> telephone
  
  
  web %>%
  	html_nodes('.vip-details .description') %>%
  	html_text() %>%
  	stri_extract_all_words() %>%
  	unlist() %>%
  	paste(collapse = " ") -> opis
  
  web %>%
  	html_nodes('.main img') %>%
  	html_attr('src') -> link_do_zdj
  
  return(list(cena = cena, wielkosc = wielkosc, telephone = telephone, opis = opis))
  # zapisz do bazy danych
}
