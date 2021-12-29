
# Proyecto: Información Geográfica
# Autor: Lauti Cantar

# Este archivo tiene por finalidad hacer un listado de todos los radios censales
# del país. Para eso abre todos los archivos shp y hace una larga lista con 
# todos los IDs.


# ---------------------------------------------------------------------------------------
#                                 0. Loading packages & data
# ---------------------------------------------------------------------------------------

# Cargando los paquetes
source("02_scripts/00_paquetes.R")

# Lista de provincias a recorrer
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

radios.pais <- data.frame()
# radios.pais <- st_sf(row.names = c("toponimo_i",
#                                    "link",
#                                    "varon",
#                                    "mujer",
#                                    "totalpobl",
#                                    "hogares",
#                                    "viviendasp",
#                                    "viv_part_h",
#                                    "geometry"))

# radios_pais <- st_sf(st_sfc())

for (i in 1:length(provincias)) {
  
  print(i)
  archivo <- paste0("01_datos/01_datos_originales/01_radios_censales_por_provincia/Codgeo_",
                    provincias[i], 
                    "_con_datos/")
  
  shape <- paste0(provincias[i], "_con_datos")
  
  rc <- st_read(dsn = archivo, layer = shape)
  rc <- as.data.frame(rc ) #%>% select(-geometry))
  
  radios.pais <- rbind(radios.pais, rc)
  # radios.pais <- st_bind_cols(radios.pais, rc)
  
  print(nrow(radios.pais))

}

# Radios Censales de CABA
capital <- st_read("01_datos/01_datos_originales/01_radios_censales_por_provincia/Codgeo_CABA_con_datos/", layer = "CABA_con_datos")

capital <- capital %>% 
  select(LINK, VARONES, MUJERES, TOT_POB, HOGARES, VIV_PART, VIV_PART_H, geometry) %>% 
  rename(link = LINK,
         varon = VARONES,
         mujer = MUJERES, 
         totalpobl = TOT_POB,
         hogares = HOGARES,   
         viviendasp = VIV_PART,
         viv_part_h = VIV_PART_H) %>% 
  mutate(toponimo_i = NA) %>% 
  as.data.frame()

# Uniendo los archivos
radios_total_pais <- rbind(radios.pais, capital) %>% 
  select(-c(toponimo_i, geometry))


# Guardando el archivo
write.csv(radios_total_pais, "01_datos/02_datos_finales/total_radios_censales_pais.csv", 
          row.names = FALSE)

openxlsx::write.xlsx(radios_total_pais, "01_datos/02_datos_finales/total_radios_censales_pais.xlsx")


# Guardando el shp file
radios_pais_shp <- rbind(radios.pais, capital)

radios_pais_shp_2 <- st_as_sf(radios_pais_shp, sf_column_name = "geometry")

st_write(radios_pais_shp_2, "01_datos/02_datos_finales/radios_censales_argentina/radios_censales_argentina_shp.shp")
