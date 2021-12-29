

# Código para:                  GAS
# Desarrollado por: Lautaro Cantar - lautaro.cantar.ar@gmail.com

# --------------------------------------------------------------------------------------------------------------------
#                                             0. Loading packages & data
# --------------------------------------------------------------------------------------------------------------------

# Cargando los paquetes
source("02_scripts/00_paquetes.R")

# --------------------------------------------------------------------------------------------------------------------
#                                             1. Data Manipulation
# --------------------------------------------------------------------------------------------------------------------

# Cloacas
cloacas.url <- "http://sig.planificacion.gob.ar/layers/download/lmarcos_hogares_red_de_cloacas/csv"

cloacas <- read_csv(cloacas.url,
                    col_types = cols(
                      link = col_character(),
                      provincia = col_character(),
                      tot_hog10 = col_integer(),
                      Red_publica_de_agua = col_integer(),
                      A_camara_septica = col_integer(),
                      Solo_a_pozo_ciego = col_integer(),
                      A_hoyo_o_excavacion = col_integer(),
                      Total = col_integer(),
                      Sin_conexion_a_red = col_integer(),
                      Porcentaje_de_hogares_con_conexion_a_red = col_double(),
                      Porcentaje_de_hogares_sin_conexion_a_red = col_double())
)

# Cambiandole el nombre a las variables para tener mas homogeneidad
cloacas <- cloacas %>% 
  dplyr::select(link, provincia, tot_hog10, Red_publica_de_agua, A_camara_septica, Solo_a_pozo_ciego,
                A_hoyo_o_excavacion, Sin_conexion_a_red) %>% 
  rename(Radio_Censal = link,
         Provincia = provincia,
         Cantidad_hogares = tot_hog10,
         cloacas_conexion_red_publica = Red_publica_de_agua,
         cloacas_conexion_camara_septica = A_camara_septica,
         cloacas_conexion_pozo_ciego = Solo_a_pozo_ciego,
         cloacas_conexion_hoyo_o_excavacion = A_hoyo_o_excavacion,
         cloacas_total_sin_conexion_a_red = Sin_conexion_a_red) %>% 
  mutate(cloacas_pje_hogares_red = cloacas_conexion_red_publica/Cantidad_hogares)

# Editando la variable "Radio_Censal" para poder hacer el merge
cloacas$Radio_Censal <- ifelse(nchar(cloacas$Radio_Censal) == 8, 
                            paste0("0", cloacas$Radio_Censal), cloacas$Radio_Censal)

# --------------------------------------------------------------------------------------------------------------------
#                               2. Exportacion del archivo
# --------------------------------------------------------------------------------------------------------------------

# Guardando el archivo CSV
write.csv(cloacas, "01_datos/02_datos_finales/cloacas_radiocensal.csv", 
          row.names = FALSE)

# Guardando el archivo XSLX
openxlsx::write.xlsx(cloacas, "01_datos/02_datos_finales/cloacas_radiocensal.xlsx")

