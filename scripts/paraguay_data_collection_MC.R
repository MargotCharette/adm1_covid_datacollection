
library(dplyr)
library(readxl)
library(XML)
library(openxlsx)
library(lubridate)

#SOURCE DATA: https://public.tableau.com/app/profile/mspbs/viz/COVID19PY-Registros/Descargardatos
#NOTE: for now still need to re-save data as CSV (issue with format)


#add here package to be able to use relative paths
pacman::p_load(
  tidyverse,    # data management + ggplot2 graphics (will load core tidyverse packages such as: ggplot2, dplyr, tidyr)
  lubridate,    # working with dates/epiweeks
  skimr,        # summary stats ov variables in dataset
  rio,          # file import/export
  here,         # relative filepaths
  janitor
)

#cases
#modify file reading script, so it works with relative paths (make sure to not skip first row when importing as well as first column)
PRY <- import(here("data", "downloads", "paraguay", "Descargar_datos.csv"))                   #using relative paths
# Import cases
#PRY <- data.frame(read.csv(file = "~/PAHO/GIS/Paraguay/Descargar_datos_data.csv"))
#JUST IN CASE ALTERNATIVE OPTION: PRY <- data.frame(read.csv(file = "C:/Users/PC/Documents/GitHub/adm1_covid_datacollection/data/downloads/paraguay/Descargar_datos.csv"))

head(PRY)
PRY <- PRY %>% 
  janitor::clean_names()
head(PRY)

# Filter for dates - values before Saturday' date for the end of week data

PRY_cases <- PRY %>% filter(fecha_confirmacion <= '12/31/2021' )

PRY_cases <- PRY  %>% 
  group_by(departamento_residencia) %>% 
  count(departamento_residencia)


# Import deaths
PRY_2 <- import(here("data", "downloads", "paraguay", "FALLECIDOS.csv"), header = T)                   #using relative paths
#PRY_2 <- data.frame(read.csv(file = "~/PAHO/GIS/Paraguay/FALLECIDOS_data.csv"))

head(PRY_2)
PRY_2 <- PRY_2 %>% 
  janitor::clean_names()
head(PRY_2)

PRY_deaths <- PRY_2 %>% filter(fecha_obito < '12/31/2021')

PRY_deaths <- PRY_2 %>%
  group_by(departamento_residencia) %>%
  count(departamento_residencia)

PRY_table <- left_join(PRY_cases, PRY_deaths, by=c("departamento_residencia"="departamento_residencia"))
PRY_table$departamento_residencia[PRY_table$departamento_residencia == "Ã'EEMBUCU"] <- "NEEMBUCU"


write.csv(PRY_table, here("data", "clean", "paraguay", "PRY_adm1.csv"))

