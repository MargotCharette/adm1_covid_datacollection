library(dplyr)
library(readxl)
library(XML)
library(openxlsx)
library(lubridate)


# Filter for dates - values before Saturday' date for the end of week data

# Import cases
PRY <- data.frame(read.csv(file = "~/PAHO/GIS/Paraguay/Descargar_datos_data.csv"))
head(PRY)

PRY_cases <- PRY %>% filter(Fecha.Confirmacion <= '12/24/2021' )

PRY_cases <- PRY  %>% 
  group_by(Departamento.Residencia) %>% 
  count(Departamento.Residencia)


# Import deaths
PRY_2 <- data.frame(read.csv(file = "~/PAHO/GIS/Paraguay/FALLECIDOS_data.csv"))
head(PRY_2)


PRY_deaths <- PRY_2 %>% filter(Fecha.Obito < '12/24/2021')

PRY_deaths <- PRY_2 %>%
  group_by(Departamento.Residencia) %>%
  count(Departamento.Residencia)

PRY_table <- left_join(PRY_cases, PRY_deaths, by=c("Departamento.Residencia"="Departamento.Residencia"))
PRY_table$Departamento.Residencia[PRY_table$Departamento.Residencia == "Ã'EEMBUCU"] <- "NEEMBUCU"


write.xlsx(PRY_table, file="~/PAHO/GIS/Paraguay/PRY_adm1.xlsx")

