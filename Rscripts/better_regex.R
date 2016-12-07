good

Szukam od stycznia dziewczyny
poszukuje osoby
Szukamy osoby
Szukam współlokatorki
szukamy trzeciej
szukam współlokatorki
Szukam współlokatorki
Poszukuję osoby
szukam współlokatora
Poszukuję osoby
poszukuję osoby
szukam Kobiety

bad

Poszukuję pokoju
Poszukuję pokoju
Szukam od zaraz pokoju
Szukam pokoju

tricky

poszukuję osoby która chciałaby zamieszkać w nieprzechodnim pokoju

1. szukam OSOBY (do) pokoju
2. szukam POKOJU (do) wynajecia od osoby

search_keys <- c("szukam", "poszukuj[eę]") %>% paste0(collapse = "|")
person_keys <- c(
  "osoby", "dziewczyny", "kobiety", "wsp[oó][lł]lokator[ka]", "faceta",
  "ch[lł]opaka", "m[eę][zż]czyzny"
) %>%
  paste0(collapse = "|")
phrase <-
  "poszukuję fajnej osoby która chciałaby zamieszkać w nieprzechodnim pokoju"
grep(
  paste0("(", search_keys, ")((?!", person_keys, ").)*pok[oó]j"),
  phrase,
  ignore.case = TRUE,
  perl = TRUE
)

Nie wyłapuje pewnych niuansów:
  
1. 2 x szukam "Witam od 1 grudnia szukam współlokatora mężczyzny a nie kobiety
do kawalerki na Woli Nie szukam obcokrajowców Szukam tylko Polaka Jest to
kawalerka a nie mieszkanie z dwoma oddzielnymi pokojami Mieszkanie jest w pełni
wyposażone i wykończone jest o dość wysokim standardzie.Kuchnia w pełni
wyposażona zarówno w sprzęty i wszystkie rzeczy kuchenne W mieszkaniu internet
bezprzewodowy i TV kablowa Z opłat obowiązujących co miesiąc to prąd i woda ok
100 zł inne media wliczone w cenę czynszu Szukam osoby przede wszystkim dbającej
o czystość w pomieszczeniach wspólnego użytkowania Fajnie by było stworzyć
kumpelskie relacje Chętnie poszukuję osoby na dłuższy okres czasu wynajmowania
Mam 33 lata nie palę Pracuje od pon sob Szukam osoby pracującej max do 35 lat"

2. sympatyczne kobitki, szukamy trzeciej "Pokój umeblowany zamykany na klucz
w cichej i zielonej okolicy Z dobrym dojazdem do Mordoru i innych części
Warszawy W mieszkaniu dwie sympatyczne kobitki szukamy trzeciej do naszego temu
Tylko obywatele Polski W cenie wszystkie media i internet Dostępne choćby od
zaraz zapraszam i gorąco polecam Kontakt tylko telefoniczny Pokój umeblowany
zamykany na klucz w cichej i zielonej okolicy Z dobrym dojazdem do Mordoru
i innych części Warszawy W mieszkaniu dwie sympatyczne kobitki szukamy trzeciej
do naszego temu Tylko obywatele Polski W cenie wszystkie media i internet
Dostępne choćby od zaraz zapraszam i gorąco polecam Kontakt tylko telefoniczny"
  
W próbie mieszkań i domów nikt niczego nie szukał.