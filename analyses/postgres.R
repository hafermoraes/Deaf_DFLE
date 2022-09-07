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

## dbGetQuery(conn, "select * from ed2019.microdata limit 5") %>% View
## dbGetQuery(conn, "select * from ed2019.datadict") %>% View

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
# Conclusion: overall total and totals by gender are OK, but among health perception the numbers do not match

paa2022_raw <- svytable(
  formula=~c008 + # age at interview date
    g058 +        # level of hearing impairment
    g057 +        # level of hearing impairment (despite use of hearing devices)
    c006 +        # gender 
    g05801 +      # use of LIBRAS, the Brazilian sign language
    q092 +        # ever diagnosed with depression by a physician
    q11006,       # ever diagnosed with anxiety by a physician
  design = pns2019_posterior,
)

paa2022_pns <- paa2022_raw %>% 
  as.data.frame(stringsAsFactors = FALSE) %>%
  mutate(
    c008 = as.numeric(c008),
    gender = factor( c006, levels = 1:2, labels = c('male', 'female')),
    libras = factor( g05801, levels = 1:2, labels = c('yes', 'no')),
    age_grp = cut( 
      c008, 
      breaks = c( 0, 1, seq(from=5,to=90, by=5), 120),
      include.lowest = TRUE,
      right = FALSE
    ),
    combined = case_when(
      g057 == ' ' ~ g058,
      g058 == ' ' ~ g057,
    ),
    hearing_impairment_level = case_when(
      combined %in% c('3', '4') ~ 'Fully or Heavily impaired',
      combined %in% c('1', '2') ~ 'Any or some impairment',
      # TRUE ~ 'Ignored or missing information'
    ),
    diagnosed_depression = q092,
    diagnosed_anxiety = q11006,
  ) 
  

sum(paa2022_pns$Freq)  # estimated brazilian population in 2019

# Exploratory Data Analysis

# ever diagnosed with depression by a physician (g058)
paa2022_pns %>%
  na.omit() %>%
  group_by( hearing_impairment_level, age_grp, gender, diagnosed_depression) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2,3)
    ,names_from = 4
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  ggplot( aes( x = age_grp, y=pct*100, group = hearing_impairment_level, colour = hearing_impairment_level)) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    ,title = 'Depression prevalence'
    ,subtitle = 'Comparison by age band among levels of hearing impairment'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
  ) + 
  facet_wrap(~gender, ncol=1)

# ever diagnosed with anxiety by a physician (q11006)
paa2022_pns %>% 
  na.omit() %>%
  group_by( hearing_impairment_level, age_grp, gender, diagnosed_anxiety) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2,3)
    ,names_from = 4
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  ggplot( aes( x = age_grp, y=pct*100, group = hearing_impairment_level, colour = hearing_impairment_level)) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    ,title = 'Anxiety prevalence'
    ,subtitle = 'Comparison by age band among levels of hearing impairment'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
  ) +
  facet_wrap(~gender, ncol=1)


# "Know Libras"
sum( subset( paa2022_pns, g05801 == '1' )$Freq )

# relation between g057 and g058
paa2022_pns %>% 
  group_by( g057, g058 ) %>%
  summarise( n = sum(Freq)) %>% 
  mutate( 
    combined = case_when(
      g057 == ' ' ~ g058,
      g058 == ' ' ~ g057,
    )
  ) 

paa2022_pns %>% 
  filter( g05801 == '1' ) %>%     # only users of Libras
  mutate( 
    combined = case_when(
      g057 == ' ' ~ g058,
      g058 == ' ' ~ g057,
    )
  ) %>%
  group_by( c008, combined ) %>%
  summarise( n = sum(Freq)) %>% 
  pivot_wider(id_cols = 1, names_from = 2, values_from = 3)

paa2022_pns %>% 
  filter( g05801 == '1' ) %>%     # only users of Libras
  mutate(
    age_grp = cut( c008, 
                   breaks = c( seq(from=0,to=80, by=5), 150), 
                   include.lowest = TRUE,
                   right = FALSE
                   ),
    combined = case_when(
      g057 == ' ' ~ g058,
      g058 == ' ' ~ g057,
    )
  ) %>%
  na.omit() %>%
  group_by( age_grp, combined ) %>%
  summarise( n = sum(Freq)) %>% 
  pivot_wider(id_cols=1, names_from=2, values_from = 3) %>%
  mutate( 
    den = `1` + `2` + `3` + `4`,
    pct1 = ifelse( den == 0, 0, `1` / den),
    pct2 = ifelse( den == 0, 0, `2` / den),
    pct3 = ifelse( den == 0, 0, `3` / den),
    pct4 = ifelse( den == 0, 0, `4` / den),
  )
  
  
# among users of Libras
# ever diagnosed with depression by a physician (g058)
paa2022_pns %>% 
  filter( g05801 == '1' ) %>% # only users of Libras
  group_by( age_grp, gender, diagnosed_depression) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2)
    ,names_from = 3
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  ggplot( aes( x = age_grp, 
               y=pct*1e2, 
               group = gender, 
               colour = gender
               )
          ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    ,title = 'Depression prevalence among users of Brazilian Sign Language'
    ,subtitle = 'Comparison by 5-year age band and gender'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
  ) 

# among users of Libras
# ever diagnosed with anxiety by a physician (q11006)
paa2022_pns %>% 
  filter( g05801 == '1' ) %>% # only users of Libras
  group_by( age_grp, gender, diagnosed_anxiety) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2)
    ,names_from = 3
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  ggplot( aes( x = age_grp, 
               y=pct*1e2, 
               group = gender, 
               colour = gender
  )
  ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    ,title = 'Anxiety prevalence among users of Brazilian Sign Language'
    ,subtitle = 'Comparison by 5-year age band and gender'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
  ) 

# Depression (diagnosed by a physician)
# Comparison between users and not users of Libras
paa2022_pns %>% 
  group_by( age_grp, gender, libras, diagnosed_depression) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2,3)
    ,names_from = 4
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  na.omit() %>%
  ggplot( 
    aes( x = age_grp, 
               y=pct*1e2, 
               group = libras, 
               colour = libras
    )
  ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    ,title = 'Depression prevalence'
    ,subtitle = 'Comparison by 5-year age band, gender and knowledge of Brazilian Sign Language'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group ='knows brazilian sign language (Libras)'
    ,colour='knows brazilian sign language (Libras)'
  ) + 
  theme(
    legend.position = 'top'
  ) + 
  facet_wrap(~gender)


# Anxiety (diagnosed by a physician)
# Comparison between users and not users of Libras
paa2022_pns %>% 
  group_by( age_grp, gender, libras, diagnosed_anxiety) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = c(1,2,3)
    ,names_from = 4
    ,values_from = n
  ) %>% 
  mutate(
    pct = ifelse( `1`+`2`== 0, 0, `1` / (`1` + `2`))
  ) %>% 
  na.omit() %>%
  ggplot( 
    aes( x = age_grp, 
         y=pct*1e2, 
         group = libras, 
         colour = libras
    )
  ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    ,title = 'Anxiety prevalence'
    ,subtitle = 'Comparison by 5-year age band, gender and knowledge of Brazilian Sign Language'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group ='knows brazilian sign language (Libras)'
    ,colour='knows brazilian sign language (Libras)'
  ) + 
  theme(
    legend.position = 'top'
  ) + 
  facet_wrap(~gender)

# hearing impairment prevalence by gender and 5-year age band
paa2022_pns %>% 
  mutate(
    hearing_impairment_level = case_when(
      combined == '1' ~ 'none',
      combined == '2' ~ 'some',
      combined == '3' ~ 'much',
      combined == '4' ~ 'full',
      TRUE ~ 'undisclosed'
    )
  ) %>%
  group_by( gender, age_grp, hearing_impairment_level) %>%
  summarise(
    n = sum( Freq )
  ) %>% 
  pivot_wider(
    id_cols = 1:2,
    names_from = 3,
    values_from = 4
  ) %>% 
  mutate( 
    den = full + much + none + some + undisclosed,
    full = full / den,
    much = much / den,
    none = none / den,
    some = some / den,
    undisclosed = undisclosed / den
    ) %>%
  select( -c(undisclosed,den)) %>% 
  pivot_longer(
    cols = 3:6,
    names_to = 'hearing_impairment_level',
    values_to = 'prevalence'
  ) %>% 
  ggplot( 
    aes( x = age_grp, 
         y=prevalence*1e4, 
         colour = hearing_impairment_level, 
         group = hearing_impairment_level
         )
    ) + 
  geom_point() + geom_line()+
  labs(
    y = 'prevalence by 10.000 people'
    ,x = '5-year age band'
    ,title = 'Hearing impairment prevalence'
    ,subtitle = 'Comparison by 5-year age band among levels of hearing impairment and gender'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
  ) + 
  facet_wrap(~gender, ncol=4,scales = 'free_y')

# srvyr, if needed ...
#poststr <- data_posterior %>% as_survey()
#matr <- poststr %>%
#  filter( age == 15 ) %>%
#  group_by(gender, hearing_impairment_level, brazilian_sign_language_use) %>%
#  summarise( n = survey_total())


# ideia validada com luciana em 06.09.2022
# prevalencia de depressao por (1) grau de dificuldade em ouvir, (2) idade quinquenal e (3) sexo
# usar tabua abreviada do censo 2010


# restringir a alguns graus de dificuldade de ouvir 
# separar em (1) usa libras, (2) sexo e (3) idade quinquenal
# calcular prevalência de depressão
# usar tabua abreviada do censo 2010
