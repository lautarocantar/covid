

# Código para:                  AGUA
# Desarrollado por: Lautaro Cantar - lautaro.cantar.ar@gmail.com

# --------------------------------------------------------------------------------------------------------------------
#                                             0. Loading packages & data
# --------------------------------------------------------------------------------------------------------------------

# Cargando los paquetes
source("02_scripts/00_paquetes.R")

# --------------------------------------------------------------------------------------------------------------------
#                                             1. Data Manipulation
# --------------------------------------------------------------------------------------------------------------------

# Agua
agua.link <- "http://sig.planificacion.gob.ar/layers/download/lmarcos_hogares_red_de_agua/csv"
# agua <- read_csv("Datos/Hogares con red publica de agua por radio censal/hogares_red_de_agua_layer_srs.csv",

agua <- read_csv(agua.link,
                 col_types = cols(
                   Link = col_character(),
                   Nombre_de_provincia = col_character(),
                   Total_de_hogares_2010 = col_integer(),
                   Red_publica_de_agua = col_integer(),
                   Perforacion_con_bomba_a_motor = col_integer(),
                   Perforacion_con_bomba_manual = col_integer(),
                   Pozo = col_integer(),
                   Transporte_por_cisterna = col_integer(),
                   Agua_delluvia_rio_o_canal = col_integer(),
                   Total = col_integer(),
                   Total_sin_red = col_integer(),
                   Porcentaje_dehogares_con_red_de_agua = col_double(),
                   Porcentaje_de_hogares_sin_red_de_agua = col_double())
)


agua <- agua %>% 
  dplyr::select(Link, Nombre_de_provincia, Total_de_hogares_2010, Red_publica_de_agua, Perforacion_con_bomba_a_motor,
                Perforacion_con_bomba_manual, Pozo, Transporte_por_cisterna, Agua_delluvia_rio_o_canal, Total_sin_red) %>% 
  rename(Radio_Censal = Link,
         Provincia = Nombre_de_provincia,
         Cantidad_hogares = Total_de_hogares_2010,
         agua_conexion_red_publica = Red_publica_de_agua,
         agua_perforacion_con_bomba_a_motor = Perforacion_con_bomba_a_motor,
         agua_perforacion_con_bomba_manual = Perforacion_con_bomba_manual,
         agua_conexion_a_pozo = Pozo,
         agua_transporte_por_cisterna = Transporte_por_cisterna,
         agua_agua_de_lluvia_rio_o_canal = Agua_delluvia_rio_o_canal,
         agua_total_sin_conexion_a_red = Total_sin_red) %>% 
  mutate(agua_pje_hogares_red = agua_conexion_red_publica/Cantidad_hogares)

agua$Radio_Censal <- ifelse(nchar(agua$Radio_Censal) == 8, 
                            paste0("0", agua$Radio_Censal), agua$Radio_Censal)

# --------------------------------------------------------------------------------------------------------------------
#                               2. Exportacion del archivo
# --------------------------------------------------------------------------------------------------------------------

# Guardando el archivo CSV
write.csv(agua, "01_datos/02_datos_finales/agua_radiocensal.csv", 
          row.names = FALSE)

# Guardando el archivo XSLX
openxlsx::write.xlsx(agua, "01_datos/02_datos_finales/agua_radiocensal.xlsx")


