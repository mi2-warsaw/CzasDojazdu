wydobadz_aktualne_oferty <- function(wawa) {
	wawa <- 'http://www.gumtree.pl/s-pokoje-do-wynajecia/warszawa/v1c9000l3200008p1'
	read_html(wawa) %>%
		html_nodes('.href-link') %>%
		html_attr('href') %>%
		paste0('http://www.gumtree.pl', .) %>%
		sapply(schakuj)
}

wydobadz_aktualne_oferty()





