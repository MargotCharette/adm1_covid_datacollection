library(dplyr)
library(readxl)
library(XML)
library(openxlsx)

#add here package
pacman::p_load(
  tidyverse,    # data management + ggplot2 graphics (will load core tidyverse packages such as: ggplot2, dplyr, tidyr)
  lubridate,    # working with dates/epiweeks
  skimr,        # summary stats ov variables in dataset
  rio,          # file import/export
  here,         # relative filepaths
)


#cases
#using relative paths (make sure to not skip first row when importing as well as first column)
g_cases <- import(here("data", "downloads", "guatemala", "confirmados_mapa.xlsx"), skip=1)
#g_cases <- data.frame(read_excel("~/PAHO/GIS/Guatemala/confirmados_mapa.xlsx", skip=1))                 #Raj's original path
g_cases$departamento[g_cases$departamento == "EL PROGRESO"] <- "PROGRESO"
g_cases$departamento[g_cases$departamento == "SIN DATOS"] <- "UNASSIGNED"

g_cases <- subset(g_cases, select=-c(1, municipio, poblacion))

#calculate sum cases per department
g_cases_2 <- aggregate(g_cases$casos, by=list(Category=g_cases$departamento), FUN=sum)
print(g_cases_2)



#deaths
#use relative paths for deaths too
#careful: it appears that the fallecidos download named 'casos' the death column...
g_deaths <- import(here("data", "downloads", "guatemala", "fallecidos_mapa.xlsx"), skip=1)
#g_deaths <- data.frame(read_excel("~/PAHO/GIS/Guatemala/fallecidos_mapa.xlsx", skip=1))                   #Raj's original path

#label the unassigned data and clean spelling
g_deaths$departamento[g_deaths$departamento == "NO REFIERE"] <- "UNASSIGNED"
g_deaths$departamento[g_deaths$departamento == "(OTROS)"] <- "UNASSIGNED"
g_deaths$departamento[g_deaths$departamento == "SIN DATOS"] <- "UNASSIGNED"
g_deaths$departamento[g_deaths$departamento == "EL PROGRESO"] <- "PROGRESO"


g_deaths <- subset(g_deaths, select=-c(1, municipio, poblacion))

##calculate sum deaths per department
g_deaths_2 <- aggregate(g_deaths$casos, by=list(Category=g_deaths$departamento), FUN=sum)
print(g_deaths_2)


#g <- data.frame(g_cases_2$Category, g_cases_2$x, g_deaths_2$x)
#write.xlsx(g, file="~/PAHO/GIS/Guatemala/g.xlsx")
#write.xlsx(g_cases_table, file="~/PAHO/GIS/Guatemala/g_cases.xlsx")
#write.xlsx(g_deaths_table, file="~/PAHO/GIS/Guatemala/g_deaths.xlsx")

g_cases_table <- data.frame(g_cases_2$Category, g_cases_2$x)
g_deaths_table <- data.frame(g_deaths_2$Category, g_deaths_2$x)
print(g_deaths_table)

#join cases and deaths
gtm_table <- full_join(g_cases_table, g_deaths_table, by=c("g_cases_2.Category"="g_deaths_2.Category"))
#cleaning department names in the merged gtm_table
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
gtm_table$g_deaths_2.Category[gtm_table$g_deaths_2.Category == 'PROGRESO'] <- 'PR'
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



#save clean data (line below also use relative paths)
write.csv(gtm_table, here("data", "clean", "guatemala", "g.csv"))
#write.xlsx(gtm_table, file="~/PAHO/GIS/Guatemala/g.xlsx")                                     #Raj's original path



