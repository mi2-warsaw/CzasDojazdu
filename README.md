# CzasDojazdu

[https://mi2.mini.pw.edu.pl:3838/CzasDojazdu/](https://mi2.mini.pw.edu.pl:3838/CzasDojazdu/)


## Dane

Pobierane są co 30 minut dzięki uruchomieniu skryptu `000_runme.R` .
Dane udostępniane są pod adresem [http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/dane/](http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/dane/)

## Aplikacja

Kody dostępne są w folderze  `pl/`. Aplikacja jest udostępniana pod adresem [http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/pl/](http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/pl/)

## Dockery 

Dane pobierane są dzięki konteneryzacji. Instrukcje z konfiguracją Dockera uruchamiającego pobieranie danych 
dostępne są w pliku Dockerfile. [Status builda Dockera pobierającego dane.](https://hub.docker.com/r/marcinkosinski/czasdojazdu/builds/bqh6esxcs32l6enaezq2vil/)

Aplikacja działa w obrazie Docker'a Shiny Server skonfigurowanego tutaj [https://github.com/mi2-warsaw/rocker/tree/master/shiny-extra](https://github.com/mi2-warsaw/rocker/tree/master/shiny-extra)

O motywacji używania kontenerów Docker'a można przeczytać w tym wpisie na blogu [http://r-addict.com/2016/05/13/Docker-Motivation.html](http://r-addict.com/2016/05/13/Docker-Motivation.html)


### Autorzy

- Web Harvesting & Data Management [@michałcisek](https://github.com/michałcisek)
- Shiny Application Frontend & User Experience [@abrodecka](https://github.com/abrodecka)
- Data Analysis & Visualizations [@mikolajjj](https://github.com/mikolajjj)
- Critical Elements Sewing & Mail Forwarding & Dockerization [@MarcinKosinski](https://github.com/MarcinKosinski)
- Translations & Marketing [@wchodor](https://github.com/wchodor)
