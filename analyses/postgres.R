#install.packages(c("RPostgreSQL","RPostgres"))

library(tidyverse)
library(DBI)
library(srvyr)
library(survey)
library(RPostgres)

# Connect to database 'pns'
conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("PG_DB"),
  host = Sys.getenv("PG_HOST"),
  port = Sys.getenv("PG_PORT"),
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD")
)

## dbGetQuery(conn, "SELECT * FROM ed2019.microdata LIMIT 5") %>% View
## dbGetQuery(conn, "SELECT * FROM ed2019.datadict") %>% View

data_pns_raw <- dbGetQuery( conn, statement = readr::read_file('qry_pns.sql') ) %>% 
  mutate( across(c(upa_pns,v0024,v0028,v00283,v00282,v0029,v00293,v00292), as.numeric) ) 

## Survey design (source: https://rdrr.io/cran/PNSIBGE/src/R/pns_design.R, accessed on September, 2nd 2022)
data_pns <- data_pns_raw %>% filter( !is.na(v0029))
data_prior <- survey::svydesign(
  ids=~upa_pns, 
  strata=~v0024, 
  data=data_pns, 
  weights=~v0029, 
  nest=TRUE
)
popc.types <- data.frame(
  v00293=as.character(unique(data_pns$v00293)), 
  Freq=as.numeric(unique(data_pns$v00292))
)
popc.types <- popc.types[order(popc.types$v00293),]
data_posterior <- survey::postStratify(
  design=data_prior, 
  strata=~v00293, 
  population=popc.types
)

# srvyr, if needed ...
#poststr <- data_posterior %>% as_survey()
#matr <- poststr %>%
#  filter( age == 15 ) %>%
#  group_by(gender, hearing_impairment_level, brazilian_sign_language_use) %>%
#  summarise( n = survey_total())

# auto-percepção do estado de saúde
svyby(formula=~gender, by=~health_perception, design = data_posterior, FUN=svytotal, keep.var = FALSE) %>% as.data.frame()
svytable(formula=~health_perception+gender, design=data_posterior) 

svytotal(x=~health_perception, design = data_posterior, na.rm = TRUE, keep.var = FALSE) %>% as.data.frame()
svytable(formula=~health_perception, design=data_posterior)

# usuários de libras por grau de deficiência auditiva
svyby(
  formula=~brazilian_sign_language_use, 
  by=~hearing_impairment_level, 
  design = data_posterior, 
  FUN=svytotal, 
  keep.var = FALSE) %>% 
  tibble() 

# por partes
svyby(
  formula=~brazilian_sign_language_use, 
  by=~hearing_impairment_level+gender, 
  design = subset( data_posterior, age == 17 ), 
  FUN=svytotal, 
  keep.var = FALSE) %>% 
  tibble()

conttab <- svytable(formula=~age + hearing_impairment_level + gender + brazilian_sign_language_use, design=data_posterior) 
conttab %>% as.data.frame() %>% View

contdf <- conttab %>% as.data.frame()
contdf

