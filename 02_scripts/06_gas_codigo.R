

# Código para:                  GAS NATURAL
# Desarrollado por: Lautaro Cantar - lautaro.cantar.ar@gmail.com

# --------------------------------------------------------------------------------------------------------------------
#                                             0. Loading packages & data
# --------------------------------------------------------------------------------------------------------------------

# Cargando los paquetes
source("02_scripts/00_paquetes.R")

# --------------------------------------------------------------------------------------------------------------------
#                                             1. Data Manipulation
# --------------------------------------------------------------------------------------------------------------------

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

gasesito <- gas %>% 
  mutate(suma = Con_red_de_gas + Sin_red_degas,
         igual = hogares == suma)

gas <- gas %>% 
  dplyr::select(link, hogares, Con_red_de_gas, Gas_a_granel, Gas_en_tubo, Gas_en_garrafa, Electricidad, Lena_o_carbon, 
                Otro, Sin_red_degas) %>% 
  distinct(link, .keep_all = TRUE) %>% 
  rename(Radio_Censal = link,
         Cantidad_hogares = hogares,
         gas_conexion_a_red = Con_red_de_gas,
         gas_a_granel = Gas_a_granel,
         gas_en_tubo = Gas_en_tubo,
         gas_en_garrafa = Gas_en_garrafa,
         gas_energia_por_electricidad = Electricidad,
         gas_energia_por_lena_o_carbon = Lena_o_carbon,
         gas_otra_fuente_energia = Otro,
         gas_sin_conexion_a_red = Sin_red_degas) %>% 
  mutate(gas_pje_hogares_red = gas_conexion_a_red/Cantidad_hogares,
         Radio_Censal = case_when(nchar(Radio_Censal) == 8 ~ paste0("0", Radio_Censal), 
                                  TRUE ~ Radio_Censal))

# --------------------------------------------------------------------------------------------------------------------
#                               2. Exportacion del archivo
# --------------------------------------------------------------------------------------------------------------------

# Guardando el archivo CSV
write.csv(gas, "01_datos/02_datos_finales/gas_natural_radiocensal.csv", 
          row.names = FALSE)

# Guardando el archivo XSLX
openxlsx::write.xlsx(gas, "01_datos/02_datos_finales/gas_natural_radiocensal.xlsx")

