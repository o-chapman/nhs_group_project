library(shinydashboard)
library(tidyverse)
library(janitor)
library(leaflet)
library(sf)
library(sfheaders)

beds <- read_csv(here::here("raw_data/beds_by_nhs_board_of_treatment_and_specialty.csv")) %>% 
  clean_names()
admissions <- read_csv(here::here("raw_data/hospital_admissions_hb_simd_20220302.csv")) %>% 
  clean_names()
hospitals <- read_csv(here::here("raw_data/current-hospital_flagged20211216.csv")) %>% 
  clean_names()

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

hospitals %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  # addProviderTiles(providers$CartoDB.Voyager) %>%
  addCircleMarkers(lng = ~x,
                   lat = ~y,
                   color = "purple",
                   fillOpacity = 0.5,
                   popup = ~paste0(location_name, "<br>", address_line, "<br>", 
                                   postcode), 
                   clusterOptions = markerClusterOptions())
