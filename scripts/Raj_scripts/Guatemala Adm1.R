library(dplyr)
library(readxl)
library(XML)
library(openxlsx)
g_cases <- data.frame(read_excel("~/PAHO/GIS/Guatemala/confirmados_mapa.xlsx", skip=1))
g_cases <- subset(g_cases, select=-c(1, municipio, poblacion))
print(g_cases)
g_cases_2 <- aggregate(g_cases$casos, by=list(Category=g_cases$departamento), FUN=sum)
print(g_cases_2)
g_cases_2$Category[g_cases_2$Category == "EL PROGRESO"] <- "PROGRESO"
g_cases_2$Category[g_cases_2$Category == "SIN DATOS"] <- "UNASSIGNED"
g_deaths <- data.frame(read_excel("~/PAHO/GIS/Guatemala/fallecidos_mapa.xlsx", skip=1))
g_deaths <- subset(g_deaths, select=-c(1, municipio, poblacion))
print(g_deaths)
g_deaths_2 <- aggregate(g_deaths$casos, by=list(Category=g_deaths$departamento), FUN=sum)
print(g_deaths_2)
g_deaths_2$Category[g_deaths_2$Category == "EL PROGRESO"] <- "PROGRESO"
g_deaths_2$Category[g_deaths_2$Category == "SIN DATOS"] <- "UNASSIGNED"
#g <- data.frame(g_cases_2$Category, g_cases_2$x, g_deaths_2$x)
#write.xlsx(g, file="~/PAHO/GIS/Guatemala/g.xlsx")
#write.xlsx(g_cases_table, file="~/PAHO/GIS/Guatemala/g_cases.xlsx")
#write.xlsx(g_deaths_table, file="~/PAHO/GIS/Guatemala/g_deaths.xlsx")
g_cases_table <- data.frame(g_cases_2$Category, g_cases_2$x)
g_deaths_table <- data.frame(g_deaths_2$Category, g_deaths_2$x)
gtm_table <- left_join(g_cases_table, g_deaths_table, by=c("g_cases_2.Category"="g_deaths_2.Category"))
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'ALTA VERAPAZ'] <- 'AV'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'BAJA VERAPAZ'] <- 'BV'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'CHIMALTENANGO'] <- 'CM'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'CHIQUIMULA'] <- 'CQ'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'ESCUINTLA'] <- 'ES'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'GUATEMALA'] <- 'GU'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'HUEHUETENANGO'] <- 'HU'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'IZABAL'] <- 'IZ'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'JALAPA'] <- 'JA'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'JUTIAPA'] <- 'JU'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'PETEN'] <- 'PE'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'PROGRESO'] <- 'PR'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'QUETZALTENANGO'] <- 'QZ'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'QUICHE'] <- 'QC'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'RETALHULEU'] <- 'RE'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'SACATEPEQUEZ'] <- 'SA'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'SAN MARCOS'] <- 'SM'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'SOLOLA'] <- 'SO'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'SANTA ROSA'] <- 'SR'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'SUCHITEPEQUEZ'] <- 'SU'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'TOTONICAPAN'] <- 'TO'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'ZACAPA'] <- 'ZA'
gtm_table$g_cases_2.Category[gtm_table$g_cases_2.Category == 'UNASSIGNED'] <- '999'
gtm_table <- gtm_table[order(gtm_table$g_cases_2.Category),]
write.xlsx(gtm_table, file="~/PAHO/GIS/Guatemala/g.xlsx")
