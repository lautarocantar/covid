

informacion_radios_censales <- read_excel("01_datos/informacion_radios_censales.xlsx")


test <- informacion_radios_censales %>% 
  mutate(vulnerable = case_when(nbi_ptje_hogares_con_nbi > 0.75 |
                                  agua_pje_hogares_red < 0.25 |
                                  cloacas_pje_hogares_red  < 0.25 |
                                  pje_total_bp_en_rc > 0.5 ~ 1))

rc_vulnerables <- test %>% 
  filter(vulnerable == 1)


nrow(rc_vulnerables)/nrow(test)


olava <- dat %>% 
  filter(str_detect(link, "06791"))

table(olava$vulnerable)

98/159
