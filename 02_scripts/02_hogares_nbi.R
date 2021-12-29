
# Proyecto: Información Geográfica
# Autor: Lauti Cantar

# NECESIDADES BASICAS INSATISFECHAS


# ---------------------------------------------------------------------------------------
#                                 0. Loading packages & data
# ---------------------------------------------------------------------------------------

# Cargando los paquetes
source("02_scripts/00_paquetes.R")

# Source: https://datos.minem.gob.ar/dataset/informacion-socioeconomica-nbi-deciles

# ---------------------------------------------------------------------------------------
#                                 1. Abriendo archivos y concatenando
# ---------------------------------------------------------------------------------------

# Falta Tucuman!

# URL de cada provincia
buenos.aires.url <- "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/e8205405-702d-4c57-ab5a-18e1421a9601/download/informacin-socioeconmica-nbi-buenos-aires-deciles-.csv"
caba.url <-         "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/269aed84-181b-4274-85e5-b7705962c0e7/download/informacin-socioeconmica-nbi-ciudad-de-buenos-aires-deciles-.csv"
catamarca.url <-    "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/084d2ec1-6b0f-443f-a2fb-8538d145090b/download/informacin-socioeconmica-nbi-catamarca-deciles-.csv"
chaco.url <-        "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/f4541751-fa9d-4c39-8024-7b7c3cd494ec/download/informacin-socioeconmica-nbi-chaco-deciles-.csv"
chubut.url <-       "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/bb53d0b5-8cbe-4269-888f-3d22431d35f8/download/informacin-socioeconmica-nbi-chubut-deciles-.csv"
cordoba.url <-      "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/de9c34dd-2a9f-4c36-acd7-3dd3ceab1573/download/informacin-socioeconmica-nbi-ba-deciles-.csv"
corrientes.url <-   "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/8b71b6f0-3028-4dc6-97d4-49fb0d6c3e70/download/informacin-socioeconmica-nbi-corrientes-deciles-.csv"
entre.rios.url <-   "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/01182cec-f6aa-4b98-bd1f-b102708b6c0b/download/informacin-socioeconmica-nbi-entre-ros-deciles-.csv"
formosa.url <-      "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/516d29a3-65ca-4ef2-87f6-ccec9a2ae4f9/download/informacin-socioeconmica-nbi-formosa-deciles-.csv"
jujuy.url <-        "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/4aa3324a-8b5a-4d28-81fc-983ac528899f/download/informacin-socioeconmica-nbi-jujuy-deciles-.csv"
la.pampa.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/7e1e94f4-f1db-42ad-adf7-fd5b3524d476/download/informacin-socioeconmica-nbi-la-pampa-deciles-.csv"
la.rioja.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/b248e29a-db71-4e81-8606-5d5d040fd406/download/informacin-socioeconmica-nbi-la-rioja-deciles-.csv"
mendoza.url <-      "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/5fafe937-abb0-4948-8783-377a5d84aa6c/download/informacin-socioeconmica-nbi-mendoza-deciles-.csv"
misiones.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/c243dc15-451a-4621-9e23-012c8fd6312e/download/informacin-socioeconmica-nbi-misiones-deciles-.csv"
neuquen.url <-      "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/82492cbd-9aa2-4040-ab6d-6968e1121cee/download/informacin-socioeconmica-nbi-neuqun-deciles-.csv"
rio.negro.url <-    "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/bd7c20e5-ddad-4132-b78f-5043dad315ce/download/informacin-socioeconmica-nbi-rio-negro-deciles-.csv"
salta.url <-        "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/f8fdf36a-c084-43da-8352-3ad867576464/download/informacin-socioeconmica-nbi-salta-deciles-.csv"
san.juan.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/9fddc166-f4a1-4063-b293-ba150845fb0c/download/informacin-socioeconmica-nbi-san-juan-deciles-.csv"
san.luis.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/51a1aae3-f8a5-44f6-8228-7c60d72077cd/download/informacin-socioeconmica-nbi-san-luis-deciles-.csv"
santa.cruz.url <-   "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/bb0486eb-d734-46ef-adb4-4c07998161fe/download/informacin-socioeconmica-nbi-santa-cruz-deciles-.csv"
santa.fe.url <-     "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/9b8471e6-1ca5-4790-a64c-b54723e1b29d/download/informacin-socioeconmica-nbi-santa-fe-deciles-.csv"
santiago.del.estero.url <- "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/52c2f865-675a-4abe-9cd6-f6cbaf56e870/download/informacin-socioeconmica-nbi-santiago-del-estero-deciles-.csv"
tierra.del.fuego.url <- "http://datos.minem.gob.ar/dataset/9c116c36-f483-443b-9f4d-0b26c4a461e8/resource/448d0b1b-a2ae-4203-a61c-b5ff4d67efd3/download/informacin-socioeconmica-nbi-tierra-del-fuego-deciles-.csv"
tucuman.url <- ""

# Vector para hacer el loop
provincias <- c(buenos.aires.url, caba.url, catamarca.url, chaco.url,
                chubut.url, cordoba.url, corrientes.url, entre.rios.url,
                formosa.url, jujuy.url, la.pampa.url, la.rioja.url,
                mendoza.url, misiones.url, neuquen.url, rio.negro.url,
                salta.url, san.juan.url, san.luis.url, santa.cruz.url,
                santa.fe.url, santiago.del.estero.url, tierra.del.fuego.url)

df.nbi.provincias <- data.frame()

for (i in seq(provincias)) {
  
  print(i)
  prov.url <- provincias[i]
  prov.df <- read_csv(prov.url) %>% dplyr::select(link, hcnbi, hogtot, porcconnbi)
  df.nbi.provincias <- rbind(df.nbi.provincias, prov.df)
  
}

# ---------------------------------------------------------------------------------------
#                                 2. Manipulando y guardando datos
# ---------------------------------------------------------------------------------------


df_nbi_provincias_2 <- df.nbi.provincias %>% 
  rename(link = link,
         nbi_total_hogares_con_nbi = hcnbi,
         nbi_total_hogares = hogtot,
         nbi_decil_hogares_con_nbi = porcconnbi) %>% 
  mutate(nbi_ptje_hogares_con_nbi = nbi_total_hogares_con_nbi/nbi_total_hogares)

# df_nbi_provincias_2$Link <- as.numeric(df_nbi_provincias_2$Link)


# Guardando el archivo CSV
write.csv(df_nbi_provincias_2, "01_datos/02_datos_finales/nbi_por_radios_censales_pais.csv", 
          row.names = FALSE)

# Guardando el archivo XSLX
openxlsx::write.xlsx(df_nbi_provincias_2, "01_datos/02_datos_finales/nbi_por_radios_censales_pais.xlsx")
