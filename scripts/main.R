# load in external libraries
# stick to tidyverse for similarities in syntax
library(dplyr)
library(stringr)
library(glue)
library(readr)
library(readxl)
library(tidyverse)
library(openxlsx)


# load in functions
source('scripts/functions.R')

# MSN of Aircraft
MSN <- 'MSN 40249'


# define column names
column_names_structure <- c(
  'Revision',
  'Index',
  'Task Number',
  'AMM Reference',
  'PGM',
  'Zone',
  'Access',
  'Threshold',
  'Interval',
  'Applicability',
  'Engine Applicability',
  'Man Hours',
  'Task Description'
)

column_names_systems <-  c(
  'Revision',
  'Index',
  'Task Number',
  'AMM Reference',
  'CAT',
  'Task',
  'Threshold',
  'Interval',
  'Zone',
  'Access',
  'Applicability',
  'Engine Applicability',
  'Man Hours',
  'Task Description'
)

column_names_zonal <-  c(
  'Revision',
  'Index',
  'Task Number',
  'AMM Reference',
  'Zone',
  'Access',
  'Threshold',
  'Interval',
  'Applicability',
  'Engine Applicability',
  'Man Hours',
  'Task Description'
)

# read data
path <- 'data/mpdsup.xls'
df_mpd_sheets <- path %>% excel_sheets()
df_mpd_sheets
df_mpd_systems <- read_excel(path, sheet = 'SYSTEMS AND POWERPLANT MAINTENA', skip = 7, col_names = column_names_systems)
df_mpd_structure <- read_excel(path, sheet = 'STRUCTURAL MAINTENANCE PROGRAM', skip = 6, col_names = column_names_structure)
df_mpd_zonal <- read_excel(path, sheet = 'ZONAL INSPECTION PROGRAM', skip = 6, col_names = column_names_zonal)

# manipulate the data
df_mpd_systems <- 
  df_mpd_systems %>% 
    hour_cycle_days('Threshold') %>% 
    hour_cycle_days('Interval')

df_mpd_structure <- 
  df_mpd_structure %>% 
    hour_cycle_days('Threshold') %>% 
    hour_cycle_days('Interval')

df_mpd_zonal <- 
  df_mpd_zonal %>% 
    hour_cycle_days('Threshold') %>% 
    hour_cycle_days('Interval')

#write_csv(df,"data/transformed_Structure.csv")
write.xlsx(df_mpd_systems, "data/mpd_systems.xlsx")

# look at the the data
