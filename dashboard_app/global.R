library(shinydashboard)
library(tidyverse)

library(janitor)
library(leaflet)
library(sf)
library(sfheaders)

library(lubridate)
library(tsibble)
library(ggplot2)
library(plotly)

source("global_tab1.R")




# Read in data about health boards data and clean data

hb <- read_csv("raw_data/hb.csv") %>%
  janitor::clean_names()

code_names <- hb %>%
  select(code, name) %>%
  rename("location" = code)

# Bring in information about the hospital beds occupancies and join to the health board data.

beds <- read_csv("raw_data/beds_by_nhs_board_of_treatment_and_specialty.csv") %>%
  janitor::clean_names()

beds_clean <- beds %>%
  filter(location %in% code_names$location) %>%
  select(-contains("qf")) %>%
  left_join(code_names, by = "location") %>%
  mutate(staffed_occupied_diff = all_staffed_beds - total_occupied_beds, .after = total_occupied_beds)

# Read in ans simplify boundary data, cleaning names too.

boundary_esri <- st_read(
  "raw_data/spatial_data/SG_NHS_HealthBoards_2019.shp") %>%
  st_simplify(dTolerance = 100) %>%
  janitor::clean_names() %>%
  rename(hb = hb_code) %>%
  st_transform("+proj=longlat +datum=WGS84")

# Join beds data with geometry data by the health board code.

beds_geom <- beds_clean %>% left_join(boundary_esri, by = "hb")

diff_data_areas <- read_csv("clean_data/diff_data.csv")

admissions <- read_csv(here::here("raw_data/hospital_admissions_hb_simd_20220302.csv")) %>%
  janitor::clean_names()
hospitals <- read_csv(here::here("raw_data/current-hospital_flagged20211216.csv")) %>%
  janitor::clean_names()

hospitals <- hospitals %>%
  drop_na(x_coordinate)

hospitals <- st_as_sf(hospitals,
                      coords = c("x_coordinate", "y_coordinate"),
                      crs = 27700)

# Reproject to WGS84
hospitals <- st_transform(hospitals , 4326)
hospitals <- sf_to_df(hospitals, fill = TRUE)

diff_data_hospitals <- read_csv("clean_data/diff_data_hospitals.csv")

#-----------DEMOGRAPHIC----------

# read in admissions & deprivation data, clean names
deprivation <- read_csv(here::here("raw_data/admissions_by_hb_and_deprivation.csv")) %>% 
  clean_names()

# create date column from weekly data
dep_date <- deprivation %>% 
  mutate(
    year = str_extract(week_ending, "^\\d{4}"),
    monthday = str_extract(week_ending, "\\d{4}$"),
    month = str_extract(monthday, "^\\d{2}"),
    day = str_extract(monthday, "\\d{2}$"),
    date = ymd(str_c(year, month, day)), .after = 1
  )

# change quintiles from continuous to discrete for binning
dep_date$simd_quintile <- as_factor(dep_date$simd_quintile)

# read in age & sex data, clean names
age <- read_csv(here::here("raw_data/age_data.csv")) %>% 
  clean_names()

# create columns with day, month, year and date columns
age_by_date <- age %>% 
  mutate(
    year = str_extract(week_ending, "^\\d{4}"),
    monthday = str_extract(week_ending, "\\d{4}$"),
    month = str_extract(monthday, "^\\d{2}"),
    day = str_extract(monthday, "\\d{2}$"),
    date = ymd(str_c(year, month, day)), .after = 1
  )

# remove all ages from age_group
age_date_clean <- age_by_date %>% 
  filter(!age_group == "All ages")

# remove All from sex
sex_data_clean <- age_by_date %>% 
  filter(!sex == "All")

# find greatest % diff from winter to not winter for age
max_age <- age_date_clean %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, age_group) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_max(percent_difference)

# find least % diff from winter to not winter for age
min_age <- age_date_clean %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, age_group) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_min(percent_difference)

# find greatest % diff from winter to not winter for simd
max_simd <- dep_date %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, simd_quintile) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_max(percent_difference) 

# find least % diff from winter to not winter for simd
min_simd <- dep_date %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, simd_quintile) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_min(percent_difference)

# find greatest % diff from winter to not winter for sex
max_sex <- age_by_date %>%
  filter(sex != "All") %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, sex) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_max(percent_difference)

# find least % diff from winter to not winter for sex
min_sex <- age_by_date %>%
  filter(sex != "All") %>% 
  mutate(quarter = quarter(date), .after = date) %>% 
  mutate(winter = case_when(
    quarter == 1 ~ TRUE,
    quarter > 1 ~ FALSE,
  ), .after = quarter) %>% 
  group_by(winter, sex) %>% 
  summarise(admissions = sum(number_admissions)) %>% 
  pivot_wider( values_from = admissions, names_from = winter) %>% 
  rename("winter" = "TRUE", not_winter = "FALSE") %>% 
  mutate(not_winter = not_winter/3,
         percent_difference = (100*(winter/not_winter))-100) %>% 
  slice_min(percent_difference)