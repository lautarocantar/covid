



# --------------------------------------------------------------------------------------------------------------------
#                                             0. Loading packages & data
# --------------------------------------------------------------------------------------------------------------------

# Loading packages
library(tidyverse)
library(dplyr)
library(leaflet)
library(rgdal)
library(rgeos)
library(sp)
library(sf)
library(maptools)
library(geosphere)
library(readxl)
library(mapview)


# --------------------------------------------------------------------------------------------------------------------
#                                             1. Data Manipulation
# --------------------------------------------------------------------------------------------------------------------




# Red Electrica
electrica <- read_csv("Datos/Hogares con red electrica/hogares_red_electrica_layer_srs.csv")
colnames(electrica)

# Red de gas
gas.url <- "http://sig.planificacion.gob.ar/layers/download/lmarcos_hogares_red_de_gas/csv"
gas <- read_csv(gas.url,
                col_types = cols(
                  link = col_character(),
                  hogares = col_integer(),
                  Con_red_de_gas = col_integer(),
                  Gas_a_granel = col_integer(),
                  Gas_en_tubo = col_integer(),
                  Gas_en_garrafa = col_integer(),
                  Electricidad = col_integer(),
                  Lena_o_carbon = col_integer(),
                  Otro = col_integer(),
                  Total = col_integer(),
                  Sin_red_degas = col_integer(),
                  Porcentajedehogares_con_red_de_gas = col_double(),
                  Porcentaje_de_hogares_sin_red_de_gas = col_double())
                )

gas <- gas %>% 
  dplyr::select(link, hogares, Con_red_de_gas, Gas_a_granel, Gas_en_tubo, Gas_en_garrafa, Electricidad, Lena_o_carbon, 
                Otro, Sin_red_degas) %>% 
  rename(Radio_Censal = link,
         Cantidad_hogares = hogares,
         gas_conexion_a_red = Con_red_de_gas,
         gas_a_granel = Gas_a_granel,
         gas_en_tubo = Gas_en_tubo,
         gas_en_garrafa = Gas_en_garrafa,
         gas_energia_por_electricidad = Electricidad,
         gas_energia_por_lena_o_carbon = Lena_o_carbon,
         gas_otra_fuente_energia = Otro,
         gas_sin_conexion_a_red = Sin_red_degas)



# --------------------------------------------------------------------------------------------------------------------
#                                             2. Data de datos.gob.ar
# --------------------------------------------------------------------------------------------------------------------


# ----------------------------------- Jefe de Hogar con educación media incompleta  -----------------------------------

# Source: http://datos.minem.gob.ar/dataset/informacion-socioeconomica-jefe-de-hogar-con-educacion-media-incompleta


# URL de cada provincia
buenos.aires.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/d1ba8b31-8913-4d6f-9086-f8c7df5524de/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-buenos-aires.csv"
caba.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/90c6cea1-e772-43e5-85a8-6ee952d14e99/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-ciudad-de-buenos-aires.csv" 
catamarca.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/31b9ea19-f978-4ee3-b687-338accc51f15/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-catamarca.csv"
chaco.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/c9354adc-369c-4bd6-a924-addfd608c2bc/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-chaco.csv"
chubut.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/48612341-65ee-4e95-842d-9f2855a0f9ea/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-chubut.csv"
# cordoba.url <- ""
corrientes.url <-  "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/89f0bfeb-de94-4ad6-9fb8-5bc69351caef/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-corrientes.csv"
entre.rios.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/838d25c6-7d54-437b-b8fd-97c9f64a8f14/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-entre-ros.csv"
formosa.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/cd1eb103-c0bd-4f43-bc97-28bfc0d61cd4/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-formosa.csv"
jujuy.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/d03aa4be-7b5a-4c95-a66b-b6dfb486ecf2/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-jujuy.csv"
la.pampa.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/2eb7db17-7cec-4bf1-9e0d-0872577272c3/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-la-pampa.csv"
la.rioja.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/59f1ca56-5ca9-45e7-9273-d5eb33eadcaa/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-la-rioja.csv"
mendoza.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/086290bf-ef30-4438-86a8-24460829986e/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-mendoza.csv"
misiones.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/5a2761b2-149c-461b-b7bd-a59f79b9778f/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-misiones.csv"
neuquen.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/4137ef2e-f1d9-462f-a39d-7905bf408947/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-neuqun.csv"
rio.negro.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/eac03341-dbc1-4d16-8243-2f382d75bf94/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-ro-negro.csv"
salta.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/70bc1c65-f7f8-46f2-8ef8-72f37bbe4e03/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-salta.csv"
san.juan.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/0fe200f5-338b-4750-a8be-f800453d9fb8/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-san-juan.csv"
san.luis.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/7bddba4d-864e-4d90-ba92-a0e96f89c744/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-san-luis.csv"
santa.cruz.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/e8909bcb-4864-4b1d-aef7-328b9e8fc80f/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-santa-cruz.csv" 
santa.fe.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/8a49b8f0-843d-45af-a590-42416c299144/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-santa-fe.csv"
santiago.del.estero.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/186ed79b-b515-4b2c-9183-04311a591cde/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-santiago-del-estero.csv"
# tierra.del.fuego.url <- ""
tucuman.url <- "http://datos.minem.gob.ar/dataset/4d31208b-28d1-457c-95d3-044b5870bd26/resource/2d722dd2-f5e3-4ffc-90b9-363f884ed073/download/informacin-socioeconmica-jefe-de-hogar-con-educacin-media-incompleta-tucumn.csv"


provincias.jh_emi <- c(buenos.aires.url, caba.url, catamarca.url, chaco.url,
                       chubut.url, corrientes.url, entre.rios.url,
                       formosa.url, jujuy.url, la.pampa.url, la.rioja.url,
                       mendoza.url, misiones.url, neuquen.url, rio.negro.url,
                       salta.url, san.juan.url, san.luis.url, santa.cruz.url,
                       santa.fe.url, santiago.del.estero.url, tucuman.url)
                       # cordoba.url, tierra.del.fuego.url)

df.jh_emi.provincias <- data.frame()

for (i in seq(provincias.jh_emi)) {
  
  print(i)
  prov.url <- provincias.jh_emi[i]
  prov.df <- read_csv(prov.url) %>% dplyr::select(link, hogtot, jh_total, jh_hemi)
  df.jh_emi.provincias <- rbind(df.jh_emi.provincias, prov.df)
  
}

df.jh_emi.provincias.2 <- df.jh_emi.provincias %>% 
  dplyr::select(link, jh_total, jh_hemi) %>% 
  rename(Link = link,
         JH_EMI_cantidad_de_hogares_totales = jh_total,
         JH_EMI_cantidad_de_hogares_emi = jh_hemi)

df.jh_emi.provincias.2$Link <- as.numeric(df.jh_emi.provincias.2$Link)

# --------------------------------------------------------------------------------------------------------------------
#                                             2. Data Merge
# --------------------------------------------------------------------------------------------------------------------

# Haciendo los merges
df <- agua %>% 
  left_join(cloacas) %>%                # Merging Agua y Cloacas
  left_join(gas) %>%                      # Merging Gas 
  left_join(df.nbi.provincias.2) %>% 
  left_join(df.jh_emi.provincias.2) 


