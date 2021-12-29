
# Código para:                  BARRIOS POPULARES
# Desarrollado por: Lautaro Cantar - lautaro.cantar.ar@gmail.com

# --------------------------------------------------------------------------------------------------------------------
#                                             0. Loading packages & data
# --------------------------------------------------------------------------------------------------------------------

# Loading packages
library(tidyverse)
library(rgdal)
library(rgeos)
library(sp)
library(sf)
# library(raster)
# library(geosphere)
library(readxl)

# Procedimiento:

# Los poligonos de los Barrios Populares son independientes de los poligonos de los Radios Censales: 
# un Barrio Popular puede estar en mas de un Radio Censal y, los Radios Censales pueden tener mas de un 
# Barrio Popular. Por lo tanto, el procedimiento ensayado fue el de hacer una interseccion entre ambos 
# poligonos y determinar el porentaje del Radio Censal que esta ocupado por Barrios Populares.

# --------------------------------------------------------------------------------------------------------------------
#                               1. Interseccion de los Radios Censales con los Barrios Populares
# --------------------------------------------------------------------------------------------------------------------

# Source: https://gis.stackexchange.com/questions/140504/extracting-intersection-areas-in-r

# Loading the datasets
ba_radios_censales <- st_read(dsn="../Datos/BA_nuevo/", layer = "BA_nuevo")

barrios_shp <- st_read(dsn="01_datos/01_datos_originales/02_barrios_populares/barrios-populares.shp")

# Calculando el area en KM2 de cada unos de los poligonos
ba_radios_censales$Area_RC <- st_area(ba_radios_censales)
barrios_shp$Area_BP <- st_area(barrios_shp)

# Controlando que tengan la misma proyeccion
st_crs(ba_radios_censales)
st_crs(barrios_shp)

# Creando la interseccion
int <- st_intersection(ba_radios_censales, barrios_shp)
int$area_int <- st_area(int)

# Calculando el porcentaje del RC que es un BP
int$Pje_BP_en_RC <- (int$area_int/int$Area_RC)*100

int.2 <- as.data.frame(int) %>% group_by(link) %>% summarise(Pje_Total_BP_en_RC = sum(Pje_BP_en_RC))
int.2$Pje_Total_BP_en_RC <- round(int.2$Pje_Total_BP_en_RC, 2)

colnames(int.2) <- c("Radio_Censal", "Pje_Total_BP_en_RC")

# --------------------------------------------------------------------------------------------------------------------
#                               2. Exportacion del archivo
# --------------------------------------------------------------------------------------------------------------------


write.csv(int.2, "Porcentaje Barrios Populares por Radio Censal.csv", row.names = FALSE)
# support.barrios.populares <- read_csv("Porcentaje Barrios Populares por Radio Censal.csv")
