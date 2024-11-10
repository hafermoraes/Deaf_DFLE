## ./gnur_parse_life_tables.R
library(dplyr) # %>%, select, filter, rename, transmute
library(readr) # read_delim, write_delim
library(tidyr) # pivot_longer

## TODO
## directories
tmp_dir <- '/tmp/etl/de_mpidr_hld/'
raw_dir <- paste0(tmp_dir, 'raw/')
proc_dir <- paste0(tmp_dir, 'data/')

lt2019_raw <-
  read_delim(
  file = paste0(raw_dir, 'lt2019.txt'),
  delim = ','
)

lt2019 <-
  lt2019_raw %>%
  select(10, 11, 12, 13, 15, 16, 18, 19, 20) %>%
  rename(type=1, sex=2, age_inf=3, age_sup=4, qx=5, lx=6, Lx=7, Tx=8, ex=9) %>%
  mutate(across(everything(), as.numeric)) %>%
  filter(type==2) %>%
  rowwise() %>%
  mutate(
    sex = case_when( sex == 1 ~ 'male', TRUE ~ 'female'),
    age = paste0(age_inf, '-', age_sup)
  ) %>% 
  transmute(age, sex, year = 2019,qx, lx, Lx, Tx, ex) %>%
  pivot_longer(
    cols = -c(age, sex, year),
    names_to = 'name',
    values_to = 'value'
  )



## Write to disk (csv file for database ingestion)
lt2019 %>% 
    write_delim(
        file = paste0(proc_dir, 'br2019_lifetables.csv'),
        delim = '|',
        col_names = TRUE
    )
