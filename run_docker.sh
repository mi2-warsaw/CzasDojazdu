docker run --rm -v /srv/shiny-server/CzasDojazdu/dane:/app/dane/ \
      -t czas-dojazdu-docker-scrapuj > /srv/shiny-server/CzasDojazdu/runme_out
touch /srv/shiny-server/CzasDojazdu/app/app.R