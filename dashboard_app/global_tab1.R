## HOSPITAL ADMISSIONS (WEEKLY) AS A TSIBBLE

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
  group_by(date) %>% 
  summarise(avg_admissions_by_week = mean(number_admissions)) %>% 
  as_tsibble()

date_limits <- c(min(admissions_dt$date), max(admissions_dt$date))

## WINTER SHADING FOR PLOTS

winter_shading <- c(annotate(geom = "rect",
                             xmin = as_date("2020-01-01"),
                             xmax = as_date("2020-04-01"),
                             ymin = -Inf,
                             ymax = Inf,
                             alpha = 0.3,
                             fill = "turquoise"),
                    annotate(geom = "rect",
                             xmin = as_date("2021-01-01"),
                             xmax = as_date("2021-04-01"),
                             ymin = -Inf,
                             ymax = Inf,
                             alpha = 0.3,
                             fill = "turquoise"))