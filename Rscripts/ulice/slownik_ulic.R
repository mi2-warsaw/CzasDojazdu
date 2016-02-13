# slownik ulic

library(rvest)
library(stringi)

slownik_ulice <- function(adres = 'http://www.warszawska.info/ulice-a_d.html'){
  read_html(adres) %>%
    html_nodes('table+ table table p+ p , p~ p+ p') %>%
    html_text() %>% 
    repair_encoding() %>% 
    gsub("[[:blank:]]", " ", .) %>%
    strsplit("\r\n   ") %>%
    unlist
}
  

strony <- c('http://www.warszawska.info/ulice-a_d.html',
            'http://www.warszawska.info/ulice-e_j.html',
            'http://www.warszawska.info/ulice-k_l.html',
            'http://www.warszawska.info/ulice-l_n.html',
            'http://www.warszawska.info/ulice-o_r.html',
            'http://www.warszawska.info/ulice-s_s.html',
            'http://www.warszawska.info/ulice-t_z.html')

library(pbapply)
pbsapply(strony, slownik_ulice) %>%
  unlist %>%
  write.table(file = "dicts/warszawskie_ulice.txt",
              fileEncoding = "utf8",
              quote = TRUE, 
              row.names = FALSE,
              col.names = FALSE)
# a dalej ręcznie :)

