ulice <- function(ogloszenie){
  
  require(stringi)
  
  a <- unlist(stri_extract_all_regex(ogloszenie, "(?<=(?i)(ulicy|alei)[\\s])((ś|s)w\\.\\s)?[\\p{N}\\p{L}]+((\\s|-)(\\p{Lu})+(\\p{L})+((\\s|-)(\\p{Lu})+(\\p{L})+)?)?(\\s[0-9]+(/[0-9]+)?[\\p{L}]?)?"))
  b <- unlist(stri_extract_all_regex(ogloszenie, "(?<=(?i)(ul\\.|al\\.)[\\s]?)((ś|s)w\\.\\s)?[\\p{N}\\p{L}]+((\\s|-)(\\p{Lu})+(\\p{L})+((\\s|-)(\\p{Lu})+(\\p{L})+)?)?(\\s[0-9]+(/[0-9]+)?[\\p{L}]?)?"))
  d <- unlist(stri_match_all_regex(ogloszenie, "((?i)(ulic|ulicami|ulicy|skrzy(z|ż)owaniu|ulicach|ul\\.)\\s)([\\p{N}\\p{L}]+(\\s(\\p{Lu})+(\\p{L})+)?)((\\s(i|I|A|a|z|Z)\\s)|-|/)([\\p{N}\\p{L}]+(\\s(\\p{Lu})+(\\p{L})+)?)"))
  e <- unlist(stri_extract_all_regex(ogloszenie, "(?<=(przy)[\\s])(\\p{Lu})+(\\p{L})+((\\s)(\\p{Lu})+(\\p{L})+)?"))
  
  wynik <- c(a,b,d[c(5,12)],e)
  wynik <- wynik[!is.na(wynik)]
  wynik <- unique(wynik)
  wynik <- wynik[wynik!="ul"& wynik!='al'] 
  wynik
}
