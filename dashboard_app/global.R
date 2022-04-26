library(shinydashboard)
library(tidyverse)
library(lubridate)
library(tsibble)
library(ggplot2)
library(plotly)

source("global_tab1.R")


#----------Pre & Post Covid Tab----------

emergency_admissions <- read_csv(here::here("raw_data/emergency_admissions.csv"))
a_e_attendance <- read_csv(here::here("raw_data/a_e_attendance.csv"))
deaths_weekly <- read_csv(here::here("raw_data/deaths_weekly.csv"))

emergency_admissions <- emergency_admissions %>% 
  mutate(week_ending = dmy(week_ending))

a_e_attendance <- a_e_attendance %>% 
  mutate(week_ending = dmy(week_ending))

deaths_weekly <- deaths_weekly %>% 
  mutate(week_ending = dmy(week_ending))

