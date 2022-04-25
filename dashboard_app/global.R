library(shinydashboard)
library(tidyverse)
library(lubridate)
library(tsibble)
library(ggplot2)

## HOSPITAL ADMISSIONS (WEEKLY) AS A TSIBBLE

admissions_date <- admissions %>% 
  mutate(
    year = str_extract(week_ending, "^\\d{4}"),
    monthday = str_extract(week_ending, "\\d{4}$"),
    month = str_extract(monthday, "^\\d{2}"),
    day = str_extract(monthday, "\\d{2}$"),
    date = ymd(str_c(year, month, day)),
    .before = 1
  ) %>% 
  select(-monthday)

admissions_dt <- admissions_date %>% 
  group_by(date) %>% 
  summarise(avg_admissions_by_week = mean(number_admissions)) %>% 
  as_tsibble()

start_date <- admissions_dt %>% 
  summarise(date_min = if(is.na(date)) NA else min(date, na.rm = TRUE), 
            date_min_na = is.na(date_min))
