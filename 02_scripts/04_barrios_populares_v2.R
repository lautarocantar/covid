
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
arg_radios_censales <- st_read(dsn="01_datos/02_datos_finales/radios_censales_argentina/radios_censales_argentina_shp.shp")

barrios_shp <- st_read(dsn="01_datos/01_datos_originales/02_barrios_populares/barrios-populares.shp")

# Calculando el area en KM2 de cada unos de los poligonos
arg_radios_censales$Area_RC <- st_area(arg_radios_censales)
barrios_shp$Area_BP <- st_area(barrios_shp)

# Controlando que tengan la misma proyeccion
st_crs(arg_radios_censales)
st_crs(barrios_shp)

st_transform(arg_radios_censales, 4326)
st_transform(barrios_shp, 4326)

# Creando la interseccion
int <- st_intersection(arg_radios_censales, barrios_shp)
int$area_int <- st_area(int)

# Calculando el porcentaje del RC que es un BP
int$Pje_BP_en_RC <- (int$area_int/int$Area_RC)*100

int.2 <- as.data.frame(int) %>% group_by(link) %>% summarise(Pje_Total_BP_en_RC = sum(Pje_BP_en_RC))
int.2$Pje_Total_BP_en_RC <- round(int.2$Pje_Total_BP_en_RC, 2)

colnames(int.2) <- c("Radio_Censal", "Pje_Total_BP_en_RC")


# --------------------------------------------------------------------------------------------------------------------
#                               1. Interseccion de los Radios Censales con los Barrios Populares
# --------------------------------------------------------------------------------------------------------------------

# Loading the datasets
barrios_shp <- st_read(dsn="01_datos/01_datos_originales/02_barrios_populares/barrios-populares.shp")

barrios_shp <- st_make_valid(barrios_shp)

# Calculando el area en KM2 de cada unos de los poligonos
barrios_shp$Area_BP <- st_area(barrios_shp)

barrios_shp <- barrios_shp 
# %>% 
#   mutate(provincia = case_when(provincia == "CIUDAD AUTONOMA DE BUENOS AIRES" ~ "CABA",
#                                TRUE ~ provincia))

# Listado de provincias
provincias <- c("Buenos_Aires",
                # "CABA",
                "Catamarca",
                "Chaco",
                "Chubut",
                "Cordoba",
                "Corrientes",
                "Entre_Rios",
                "Formosa",
                "Jujuy",
                "La_Pampa",
                "La_Rioja",
                "Mendoza",
                "Misiones",
                "Neuquen",
                "Rio_Negro",
                "Salta",
                "San_Juan",
                "San_Luis",
                "Santa_Cruz",
                "Santa_Fe",
                "Santiago_del_Estero",
                "Tierra_del_Fuego",
                "Tucuman")

int_total <- data.frame()

for (i in 1:length(provincias)) {
  
  print(i)
  
  # Abriendo shp de la provincia
  archivo <- paste0("01_datos/01_datos_originales/01_radios_censales_por_provincia/Codgeo_",
                    provincias[i], 
                    "_con_datos/")
  
  shape <- paste0(provincias[i], "_con_datos")
  
  rc <- st_read(dsn = archivo, layer = shape)
  rc <- st_transform(rc, 4326) %>% st_make_valid()
  
  rc$Area_RC <- st_area(rc)
  
  # Filtrando shp de Barrios Populares para esa provincia
  barrios_prov <- barrios_shp %>% 
    filter(provincia == provincias[i] %>% 
             str_replace("_", " ") %>% 
             str_to_upper())
  barrios_prov <- st_transform(barrios_prov, 4326) %>% st_make_valid()
  
  if (st_crs(rc) == st_crs(barrios_prov)) {
    
    print(" ============ vamos bien ============ ")
    
    # Creando la interseccion
    int <- st_intersection(st_make_valid(rc), 
                           st_make_valid(barrios_shp))
    
    int$area_int <- st_area(int)
    
    # Calculando el porcentaje del RC que es un BP
    int <- int %>% 
      mutate(Pje_BP_en_RC = area_int/Area_RC)
    
    int <- int %>% 
      as.data.frame() %>% 
      group_by(link) %>% 
      summarise(Pje_Total_BP_en_RC = sum(Pje_BP_en_RC)) %>% 
      mutate(Pje_Total_BP_en_RC = round(Pje_Total_BP_en_RC, 2))
    
  int_total <- rbind(int_total, int)
       
  } else {
    print(" ============ la cagaste ============= ")
  }
  

}


# Lo mismo pero con CABA

rc <- st_read("01_datos/01_datos_originales/01_radios_censales_por_provincia/Codgeo_CABA_con_datos/CABA_con_datos.shp")

rc <- st_transform(rc, 4326) %>% st_make_valid()

rc$Area_RC <- st_area(rc)

# Filtrando shp de Barrios Populares para esa provincia
barrios_prov <- barrios_shp %>% 
  filter(provincia == "CIUDAD AUTONOMA DE BUENOS AIRES" %>% 
           str_replace("_", " ") %>% 
           str_to_upper())

barrios_prov <- st_transform(barrios_prov, 4326) %>% st_make_valid()

# Creando la interseccion
int <- st_intersection(st_make_valid(rc), 
                       st_make_valid(barrios_shp))


int$area_int <- st_area(int)

# Calculando el porcentaje del RC que es un BP
int <- int %>% 
  mutate(Pje_BP_en_RC = area_int/Area_RC)

int <- int %>% 
  as.data.frame() %>% 
  group_by(LINK) %>% 
  summarise(Pje_Total_BP_en_RC = sum(Pje_BP_en_RC)) %>% 
  mutate(Pje_Total_BP_en_RC = round(Pje_Total_BP_en_RC, 2)) %>% 
  rename(link = LINK)

int_total <- rbind(int_total, int)

# --------------------------------------------------------------------------------------------------------------------
#                               2. Exportacion del archivo
# --------------------------------------------------------------------------------------------------------------------


write.csv(int_total, "01_datos/02_datos_finales/Porcentaje Barrios Populares por Radio Censal.csv", row.names = FALSE)

openxlsx::write.xlsx(int_total, "01_datos/02_datos_finales/Porcentaje Barrios Populares por Radio Censal.xlsx", row.names = FALSE)
