## HOSPITAL ADMISSIONS (WEEKLY)

#-------------OVERVIEW TAB------------------

admissions <- read_csv(here::here("raw_data/hospital_admissions_hb_simd_20220302.csv")) %>% 
  janitor::clean_names()

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
  group_by(date, year) %>% 
  summarise(avg_admissions_by_week = mean(number_admissions)) %>% 
  as_tsibble()

date_limits <- c(yearquarter(min(admissions_dt$date)), yearquarter(max(admissions_dt$date)))

## WINTER SHADING FOR PLOTS

winter_shading <- c(
  annotate(
    x = NULL,
    y = NULL,
    geom = "rect",
    xmin = as_date("2020-01-01"),
    xmax = as_date("2020-04-01"),
    ymin = -Inf,
    ymax = Inf
    ,
    alpha = 0.3,
    fill = "turquoise"
  ),
  annotate(
    x = NULL,
    y = NULL,
    geom = "rect",
    xmin = as_date("2021-01-01"),
    xmax = as_date("2021-04-01"),
    ymin = -Inf,
    ymax = Inf
    ,
    alpha = 0.3,
    fill = "turquoise"
  ),
  annotate(
    x = NULL,
    y = NULL,
    geom = "rect",
    xmin = as_date("2022-01-01"),
    xmax = as_date("2022-02-01"),
    ymin = -Inf,
    ymax = Inf
    ,
    alpha = 0.3,
    fill = "turquoise"
  ))


## BED OCCUPANCY (QUARTER)

beds <- read_csv(here::here("raw_data/beds_by_nhs_board_of_treatment_and_specialty.csv")) %>% 
  janitor::clean_names()

beds_season <- beds %>% 
  mutate(
    quarter_num = str_extract(quarter, "\\d{1}$"),
    season = recode(quarter_num, 
                    "1" = "Winter",
                    "2" = "Spring",
                    "3" = "Summer",
                    "4" = "Autumn"
    ),
    year = as.numeric(str_extract(quarter, "^\\d{4}"))
  )

beds_season_subset <- beds_season %>% 
  filter(year >= 2020) %>% 
  group_by(season, year, quarter_num) %>% 
  summarise(avg_daily_beds_perc = mean(percentage_occupancy, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(date = yearquarter(str_c(year, "Q", quarter_num)),
         seasonyear = str_c(season, " ", year))
