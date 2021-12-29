
# ---------------------------------------------------------------------------------------
#                                 0. Abiendo paquetes y definiendo funciones
# ---------------------------------------------------------------------------------------

# Cargando los paquetes
library(tidyverse)
library(janitor)


# ---------------------------------------------------------------------------------------
#                                 1. Abriendo datos y manipulandolos
# ---------------------------------------------------------------------------------------


### 01. Radios Censales ----

# Abriendo los datos
radios_total_pais <- read_csv("01_datos/02_datos_finales/total_radios_censales_pais.csv")

# Editando los datos
radios_total_pais <- radios_total_pais %>% 
  select(link, totalpobl, varon, mujer, hogares) %>% 
  mutate(rc_pje_varon = (varon/totalpobl) * 100,
         rc_pje_mujer = (mujer/totalpobl) * 100) %>% 
  rename(rc_total_poblacion = totalpobl,
         rc_total_hogares = hogares) %>% 
  select(link, rc_total_poblacion, rc_pje_varon, rc_pje_mujer, rc_total_hogares)


### 02. NBI ----

# Abriendo los datos
nbi <- read_csv("01_datos/02_datos_finales/nbi_por_radios_censales_pais.csv")

# Editando los datos
nbi <- nbi %>% 
  select(link, nbi_total_hogares, nbi_ptje_hogares_con_nbi)


### 03. Agua ----

# Abriendo los datos
agua <- read_csv("01_datos/02_datos_finales/agua_radiocensal.csv")

# Editando los datos
agua <- agua %>% 
  select(Radio_Censal, Provincia, Cantidad_hogares, agua_pje_hogares_red) %>% 
  clean_names() %>% 
  rename(link = radio_censal,
         agua_cantidad_hogares = cantidad_hogares)


### 04. Cloacas ----

# Abriendo los datos
cloacas <- read_csv("01_datos/02_datos_finales/cloacas_radiocensal.csv")

# Editando los datos
cloacas <- cloacas %>% 
  select(Radio_Censal, Cantidad_hogares, cloacas_pje_hogares_red) %>% 
  clean_names() %>% 
  rename(link = radio_censal,
         cloacas_cantidad_hogares = cantidad_hogares)



### 05. Barrios Populares ----

# Abriendo los datos
barrios_populares <- read_csv("01_datos/02_datos_finales/Porcentaje Barrios Populares por Radio Censal.csv") %>% 
  janitor::clean_names()

### 06. Gas ----

# Abriendo los datos
gas <- read_csv("01_datos/02_datos_finales/gas_natural_radiocensal.csv") %>% 
  janitor::clean_names()

# Editando los datos
gas <- gas %>% 
  select(radio_censal, cantidad_hogares, gas_pje_hogares_red) %>% 
  rename(link = radio_censal,
         gas_cantidad_hogares = cantidad_hogares)


### 07. XXX ----

# Abriendo los datos


# Editando los datos

### 08. XXX ----

# Abriendo los datos


# Editando los datos

### 09. XXX ----

# Abriendo los datos


# Editando los datos

### 10. XXX ----

# Abriendo los datos


# Editando los datos

### 11. XXX ----

# Abriendo los datos


# Editando los datos

### 12. XXX ----

# Abriendo los datos


# Editando los datos


# ---------------------------------------------------------------------------------------
#                                 2. Data Merge
# ---------------------------------------------------------------------------------------


informacion_radios_censales <- radios_total_pais %>% # Tomando como base radios censales
  left_join(nbi) %>%  # Sumando datos de 02. NBI
  left_join(agua) %>% # Sumando 03. Agua
  left_join(cloacas) %>% # Sumando 04. Cloacas
  left_join(barrios_populares) %>%  # Sumando 05. Barrios Populares
  left_join(gas) # Sumando 06. Gas
  
# ---------------------------------------------------------------------------------------
#                                 3. Data checkhing and cleaning 
# ---------------------------------------------------------------------------------------

check <- informacion_radios_censales %>%
  mutate(igual_cantidad_hogares = (rc_total_hogares + 
                                     nbi_total_hogares +
                                     agua_cantidad_hogares + 
                                     cloacas_cantidad_hogares +
                                     gas_cantidad_hogares)/rc_total_hogares)

table(check$igual_cantidad_hogares)

# Eliminando columnas repetidas
informacion_radios_censales <- informacion_radios_censales %>% 
  select(-c(nbi_total_hogares,
            agua_cantidad_hogares,
            cloacas_cantidad_hogares)) %>% 
  mutate(pje_total_bp_en_rc = case_when(is.na(pje_total_bp_en_rc) ~ 0,
                                        TRUE ~ pje_total_bp_en_rc))

# Guardando la informacion
openxlsx::write.xlsx(informacion_radios_censales,
                     "01_datos/informacion_radios_censales.xlsx")





