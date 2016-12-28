# CzasDojazdu

[http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/app/](http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/app/)


## Dane

Pobierane są co 30 minut dzięki uruchomieniu skryptu `000_runme.R`.
Dane udostępniane są [tutaj](http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/dane/).

## Aplikacja

Kody dostępne są w folderze `app/`. Aplikacja jest udostępniana [tutaj](http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/app/).

## Dockery 

Dane pobierane są dzięki konteneryzacji. Instrukcje z konfiguracją Dockera uruchamiającego pobieranie danych 
dostępne są w pliku Dockerfile. [Status builda Dockera pobierającego dane](https://hub.docker.com/r/marcinkosinski/czasdojazdu/builds/bqh6esxcs32l6enaezq2vil/).

Aplikacja działa w obrazie [Docker'a Shiny Server](https://hub.docker.com/r/krzyslom/mi2-server/).

O motywacji używania kontenerów Docker'a można przeczytać w tych wpisach
- [R 3.3.0 is another motivation for Docker](http://r-addict.com/2016/05/13/Docker-Motivation.html).
- [Rocker - explanation and motivation for Docker containers usage in applications development](http://r-addict.com/2016/10/03/Rocker-Presentation-eRka10.html)

### Autorzy

- Maintaining & Testing & Code Review & Refactoring [@krzyslom](https://github.com/krzyslom)
- Web Harvesting & Data Management [@michalcisek](https://github.com/michalcisek)
- Shiny Application Frontend & User Experience [@abrodecka](https://github.com/abrodecka)
- Data Analysis & Visualizations [@mikolajjj](https://github.com/mikolajjj)
- Critical Elements Sewing & Mail Forwarding & Dockerization [@MarcinKosinski](https://github.com/MarcinKosinski)
- Translations & Marketing [@wchodor](https://github.com/wchodor)
