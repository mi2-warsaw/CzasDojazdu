library(ggmap)

miejsca <- list()

miejsca$pierwszy <- ggmap::geocode("warszawa krasnobrodzka")
miejsca$dwa <- ggmap::geocode("warszawa kondratowicza")
miejsca$trzeci <- ggmap::geocode("warszawa bazylianska 5")

points <- do.call(rbind, miejsca)
points$adres <- c("jeden", "dwa", "trzy")

mapa <- ggmap::get_map(location = c(miejsca$dwa$lon, miejsca$dwa$lat), zoom = 12)


ggmap(mapa) +
    geom_point(data = points, aes(x = lon, y = lat), col = "red", size=4) + 
    geom_label(aes(label = adres), data = points)


# Odleglosci
ggmap::mapdist(from = c("warszawa, bazylianska 4", "Warszawa, Banacha 2"), 
               to = "warszawa, krasnobrodzka 2", 
               mode = "driving",
               output = "simple")


# Droga
r <- ggmap::route(from = "warszawa bazylianska 2", 
                  to = "warszawa krasnowrodzka 2",
                  mode = "walking")

ggmap(mapa) + 
    geom_path(
        aes(x = startLon, y = startLat), colour = "red", size = 1.5,
        data = r, lineend = "round"
    )
