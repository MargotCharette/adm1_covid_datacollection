#This script can be used to clean USA adm1 data, mainly to remove overseas territories, filter for date and merge NY and NYC rows
#Important: make sure to adjust the date for 'Saturday minus 1 day' when you run the script on Monday.
#For instance, if you are updating on *Monday, Dec. 20*, the cut off Saturday date is Sat, Dec.18 so you should filter for data as of *Dec.17* (on row 39 of this script)


pacman::p_load(
  tidyverse,    # data management + ggplot2 graphics (will load core tidyverse packages such as: ggplot2, dplyr, tidyr)
  lubridate,    # working with dates/epiweeks
  skimr,        # summary stats ov variables in dataset
  rio,          # file import/export
  here,         # relative filepaths
)

#Get the data
urlfile = "https://data.cdc.gov/api/views/9mfq-cb36/rows.csv?accessType=DOWNLOAD"
usa_covid <- read.csv(url(urlfile))
head(usa_covid)

#remove the comma separator
col_commas <- c("tot_cases", "tot_death")
usa_covid[ , col_commas] <- lapply(usa_covid[ , col_commas], function(x){ as.numeric(as.character(gsub(",","", x))) })

#merge NY and NYC together
usa_covid$state[usa_covid$state == "NYC"] <- "NY"

#define vector for overseas territories to filter out
overseas <- c("AS","GU","FSM","MP","PW", "PR","VI", "RMI")

#filter out overseas territories, select for specific date and arrange by state
usa_covid <- usa_covid %>%
  filter(!state %in% overseas)  %>%
  mutate(date = as.Date(submission_date, format = "%m/%d/%Y")) %>%
  filter(date == "2021-12-31") %>%                                                           ####MAKE SURE TO UPDATE THE DATE for Saturday - 1 day####
  group_by(state) %>%
  summarise(cases = sum(tot_cases),
            deaths = sum(tot_death)) %>%                 # to add the 2 NY values (from new york state and new york city)
  arrange(state)

print(usa_covid)

write.csv(usa_covid, here("data", "clean", "united_states", "usa.csv"))


