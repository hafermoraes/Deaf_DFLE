## ./gnur_parse_life_tables.R
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

## TODO
## directories
tmp_dir <- '/tmp/etl/br_ibge_censo_2010/'
raw_dir <- paste0(tmp_dir, 'raw/')
proc_dir <- paste0(tmp_dir, 'data/')

## Abbreviated Life Table from 2010th edition of the Brazilian Population Census
lt2010w <- bind_rows(
    ## Both sexes
    read_excel(
        path = paste0(raw_dir, 'tabela_1_1.xls'),
        sheet = 'BR',
        range = 'A6:K25',
        col_names = FALSE ) %>% mutate( sex = 'both', year = '2010' ),
    ## Male
    read_excel(
        path = paste0(raw_dir, 'tabela_1_1.xls'),
        sheet = 'BR',
        range = 'A27:K46',
        col_names = FALSE ) %>% mutate( sex = 'male', year = '2010' ),
    ## Female
    read_excel(
        path = paste0(raw_dir, 'tabela_1_1.xls'),
        sheet = 'BR',
        range = 'A48:K67',
        col_names = FALSE ) %>% mutate( sex = 'female', year = '2010' ),
)


## Data cleaning and transformation to long format for database ingestion
lt2010 <- lt2010w %>%
    rename(
        age_grp = 1, population = 2, deaths = 3, Mxn = 4, x = 5,
        Qxn = 6, lx = 7, Dxn = 8, Lxn = 9, Tx = 10, Ex = 11
    ) %>%
    mutate(
        age_grp = case_when(
            age_grp == 'Menos de 1 ano' ~ '<1',
            age_grp == '1 a 4 anos' ~ '1-4',
            age_grp == '5 a 9 anos' ~ '5-9',
            age_grp == '90 anos e mais' ~ '90+',
            TRUE ~ paste0( 
                          str_sub( age_grp, 1,2),
                          '-',
                          as.numeric( str_sub( age_grp, 1,2)) + 4
                          )
        )
    ) %>%
    pivot_longer(
        cols = -c(age_grp, sex, year),
        names_to = 'name',
        values_to = 'value'
    )

## Write to disk (csv file for database ingestion)
lt2010 %>% 
    write_delim(
        file = paste0(proc_dir, 'censo2010_lifetables.csv'),
        delim = '|',
        col_names = TRUE
    )
