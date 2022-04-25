

library(tidyverse)
library(sf)
library(shiny)


#   ----------------------GENERATING MAP DATA---------------------------------



beds <- read_csv("https://www.opendata.nhs.scot/dataset/554b0e7a-ccac-4bb6-82db-1a8b306fcb36/resource/f272bb7d-5320-4491-84c1-614a2c064007/download/beds_by_nhs_board_of_treatment_and_specialty.csv") %>% 
  janitor::clean_names()
# Read in data about health boards data and clean data

hb <- read_csv("raw_data/hb.csv") %>% 
  janitor::clean_names()

code_names <- hb %>% 
  select(code, name) %>% 
  rename("location" = code)

# Bring in information about the hospital beds occupancies and join to the health board data.

beds <- read_csv("https://www.opendata.nhs.scot/dataset/554b0e7a-ccac-4bb6-82db-1a8b306fcb36/resource/f272bb7d-5320-4491-84c1-614a2c064007/download/beds_by_nhs_board_of_treatment_and_specialty.csv") %>% 
  janitor::clean_names()

beds_clean <- beds %>% 
  filter(location %in% code_names$location) %>% 
  select(-contains("qf")) %>% 
  left_join(code_names, by = "location") %>% 
  mutate(staffed_occupied_diff = all_staffed_beds - total_occupied_beds, .after = total_occupied_beds)

# Read in ans simplify boundary data, cleaning names too.

boundary_esri <- st_read(
  "raw_data/spatial_data/SG_NHS_HealthBoards_2019.shp") %>% 
  st_simplify(dTolerance = 3000) %>% 
  janitor::clean_names() %>% 
  rename(hb = hb_code)

# Join beds data with geometry data by the health board code.

beds_geom <- beds_clean %>% left_join(boundary_esri, by = "hb")

