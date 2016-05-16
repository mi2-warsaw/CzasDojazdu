FROM rocker/r-base:latest 

MAINTAINER Marcin Kosiński "m.p.kosinski@gmail.com"

# install additional packages
RUN R -e "install.packages(c('shinydashboard', 'leaflet', 'dplyr', 'ggmap', 'stringi', 'RSQLite', 'DT', 'rvest'), repos='https://cran.rstudio.com/')"
RUN R -e "install.packages(c('stringr', 'RSelenium', 'httr', 'pbapply', 'stringdist', 'data.table'), repos='https://cran.rstudio.com/')"

RUN mkdir -p app/Rscripts app/dane
ADD Rscripts /app/Rscripts
ADD dane /app/dane
ADD 000_runme.R /app/

VOLUME /srv/shiny-server/CzasDojazdu/

WORKDIR /app

CMD R -f /app/000_runme.R