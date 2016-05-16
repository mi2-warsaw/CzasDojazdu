FROM rocker/r-base:latest 

MAINTAINER Marcin Kosiński "m.p.kosinski@gmail.com"

RUN apt-get install -y openssl-devel libcurl-devel


# install additional packages
RUN R -e "install.packages('shinydashboard', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('leaflet', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('ggmap', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('stringi', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('RSQLite', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('DT',repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('xml2', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('rvest', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('stringr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('RSelenium', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('httr', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('pbapply', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('stringdist', repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('data.table', repos='https://cran.rstudio.com/')"

RUN mkdir -p app/Rscripts app/dane
ADD Rscripts /app/Rscripts
ADD dane /app/dane
ADD 000_runme.R /app/

VOLUME /srv/shiny-server/CzasDojazdu/

WORKDIR /app

CMD R -f /app/000_runme.R
