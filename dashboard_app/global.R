library(shinydashboard)
library(tidyverse)
library(janitor)
library(leaflet)
library(sf)
library(sfheaders)




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

# hospitals <- st_as_sf(hospitals, coords = c("x_coordinate", "y_coordinate")) %>%
#   st_set_crs(27700) %>%   #set coordinate system used
#   st_transform(4326)     #transform coordinates to WGS84 coordinates

# hospitals %>%
#   leaflet() %>%
#   addProviderTiles(providers$CartoDB.Voyager) %>%
#   addCircleMarkers(data = hospitals$geometry,
#                    color = "#fdae61",
#                    fillOpacity = 0.5,
#                    radius = 2)

# Convert df to sf, 27700 is the EPSG code for the UK
hospitals <- st_as_sf(hospitals,
                      coords = c("x_coordinate", "y_coordinate"),
                      crs = 27700)

# Reproject to WGS84
hospitals <- st_transform(hospitals , 4326)
hospitals <- sf_to_df(hospitals, fill = TRUE)
