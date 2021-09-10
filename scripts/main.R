# load in external libraries
# stick to tidyverse for similarities in syntax
library(dplyr)
library(stringr)
library(glue)
library(readr)

# load in functions
source('scripts/functions.R')

# define column names
column_names <- c(
  'revision',
  'mpd_task',
  'amm_task',
  'pgm',
  'zone',
  'access',
  'threshold',
  'interval',
  'applic',
  'eng_applic',
  'man_hours',
  'task_description'
)

# read data
df <- read_csv('data/Structure.csv', skip = 4, col_names = column_names)
# manipulate the data
df <- 
  df %>% 
  hour_cycle_days('interval') %>% 
  hour_cycle_days('threshold')

write_csv(df,"data/transformed_Structure.csv")


# look at the the data
View(df)