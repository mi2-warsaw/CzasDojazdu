docker run --rm -v /srv/shiny-server/CzasDojazdu/dane:/app/dane/ \
      -t czas-dojazdu-docker-scrapuj 1 > /srv/shiny-server/CzasDojazdu/runme_out
touch /srv/shiny-server/CzasDojazdu/App/app.R

