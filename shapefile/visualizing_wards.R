library(sf)
library(googleway)
library(googlePolylines)
library(ggplot2)
library(gridExtra)


# reading in the geojson file for simple feature collection and additional fields
gau = sf::st_read("../scripts/Midvaal_shp.json")
str(gau)


plot(gau[14,'WardNumber'])


mapKey <- "AIzaSyDLoj9wkzUiTr2TYsyCYphA6Nu1pDJIFnU"

google_map(key = mapKey) %>%
  add_polygons(data = gau, polyline = "geometry", fill_colour = 'LocalMun_1', fill_opacity = 0.9, mouse_over = 'WardNumber')
