library(tidyverse)
library(DBI)
library(srvyr)
library(survey)
library(RPostgres)

# Connect to database 'paa'
conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("PG_DB"),
  host = Sys.getenv("PG_HOST"),
  port = Sys.getenv("PG_PORT"),
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD")
)

pns2019_qry <- dbGetQuery( conn, statement = readr::read_file('qry_pns.sql') )
pns2019_qry <- pns2019_qry %>%
  mutate(
    across( c(upa_pns,v0024,v0028,v00281,v00282,v00283,c008), as.numeric) 
  ) 

## Survey design (source: https://rdrr.io/cran/PNSIBGE/src/R/pns_design.R, accessed on September, 2nd 2022)
options(survey.lonely.psu="adjust")
options(survey.adjust.domain.lonely=TRUE)

pns2019_prior <- survey::svydesign(
  ids = ~upa_pns, 
  strata = ~v0024, 
  data = subset(pns2019_qry, !is.na(v0028)), 
  weights = ~v0028, 
  nest = TRUE
)
# pns2019_qry %>% select( v00283, v00282) %>% unique %>% View # also works...
popc.types <- data.frame( 
  v00283=as.character(unique(pns2019_qry$v00283)), 
  Freq=as.numeric(unique(pns2019_qry$v00282))
)
popc.types <- popc.types[order(popc.types$v00283),]
pns2019_posterior <- survey::postStratify(
  design=pns2019_prior, 
  strata=~v00283, 
  population=popc.types
)

# validation against
#   https://sidra.ibge.gov.br/tabela/7666#/n1/all/v/2667/p/all/c2/all/c12258/all/d/v2667%200/l/v,p+c2,t+c12258/resultado
round( svytable(formula=~j001+c006, design=subset(pns2019_posterior, c008 >=18))/1e3, 0)
round( svytable(formula=~c006, design=subset(pns2019_posterior, c008 >= 18))/1e3, 0)
round( sum(svytable(formula=~c006, design=subset(pns2019_posterior, c008 >= 18)))/1e3, 0)
# Conclusion: overall total and totals by sex are OK, but among health perception the numbers do not match

#   https://biblioteca.ibge.gov.br/visualizacao/livros/liv101846.pdf, page 43
round( svytable( formula=~g057 + g05801, design = subset(pns2019_posterior, c008 >= 5 & c008 <= 40)),0) %>%
  as.data.frame() %>%
  pivot_wider(id_cols=1, names_from=2, values_from=3) %>%
  rename( sim=3, nao=4) %>%
  mutate(pct_sabe_libras = sim/(sim+nao))
# makes sense but does not match...

# Unemployment among deaf adults who use brazilian sign language
round( svytable(formula=~e001 + g05801, design=subset(pns2019_posterior, g058 != 1 & c008 >=18))/1e3, 0) %>%
  as.data.frame() %>%
  pivot_wider(id_cols=1, names_from=2, values_from=3) %>%
  rename( ocupado = 1, sim=3, nao=4) %>%
  select(-2) %>%
  filter(ocupado != ' ') %>%
  mutate(
    ocupado = ifelse( ocupado == '1', 'empregado', 'desempregado'),
  ) %>%
  pivot_longer(-1, names_to = "usa_libras", values_to = "n") %>%
  pivot_wider( id_cols = 1, names_from = "ocupado", values_from = "n") %>%
  mutate(
    pct_empregado = empregado / (empregado + desempregado),
    pct_desempregado = 1 - pct_empregado
    )
## A tibble: 2 × 5
## usa_libras empregado desempregado pct_empregado pct_desempregado
## <chr>          <dbl>        <dbl>         <dbl>            <dbl>
## 1 sim              118          151         0.439            0.561
## 2 nao             3260         7700         0.297            0.703
## Warning message:
##  In `[.survey.design2`(x, r, ) : 7 strata have only one PSU in this subset.