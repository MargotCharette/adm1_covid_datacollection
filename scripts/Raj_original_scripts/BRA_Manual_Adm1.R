library(tidyr)
library(dplyr)
library(readr)
library(readxl)
library(XML)
library(openxlsx)

data1 <-  data.frame(read_delim("C:/Users/gvasudevan/Downloads/HIST_PAINEL_COVIDBR_2020_Parte1.csv", 
                     delim = ";", escape_double = FALSE, trim_ws = TRUE))

data2 <-  data.frame(read_delim("C:/Users/gvasudevan/Downloads/HIST_PAINEL_COVIDBR_2020_Parte2.csv", 
                   delim = ";", escape_double = FALSE, trim_ws = TRUE))

data3 <-  data.frame(read_delim("C:/Users/gvasudevan/Downloads/HIST_PAINEL_COVIDBR_2021_Parte1.csv", 
                   delim = ";", escape_double = FALSE, trim_ws = TRUE))

data4 <-  data.frame(read_delim("C:/Users/gvasudevan/Downloads/HIST_PAINEL_COVIDBR_2021_Parte2.csv", 
                   delim = ";", escape_double = FALSE, trim_ws = TRUE))

data_bra <- rbind(data1, data2, data3, data4) 

data_bra <- data_bra %>% filter(data=='2021-11-05') %>% drop_na(estado) %>% filter(is.na(codmun))

data_bra_cases <- aggregate(data_bra$casosAcumulado, by=list(Category=data_bra$estado), FUN=sum)

data_bra_deaths <- aggregate(data_bra$obitosAcumulado, by=list(Category=data_bra$estado), FUN=sum)

data_bra_final <- left_join(data_bra_cases, data_bra_deaths, by=c("Category" ="Category"))

write.xlsx(data_bra_final, file="C:/Users/gvasudevan/Downloads/data_bra_final.xlsx")
