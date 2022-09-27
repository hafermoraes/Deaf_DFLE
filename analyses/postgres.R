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

censo2010_qry <- dbGetQuery( conn, statement = readr::read_file('qry_censo.sql') )

censo2010 <- censo2010_qry %>%
  pivot_wider(
    id_cols = c('age_grp', 'sex')
    ,names_from = 'name'
    ,values_from = 'value'
  ) %>%
  mutate( across( c(lx, Lxn, Ex), as.numeric) )
  
censo2010 %>%
  write_csv2( 'lifetables.csv')

## dbGetQuery(conn, "select * from pns2019.microdata limit 5") %>% View
## dbGetQuery(conn, "select * from pns2019.datadict") %>% View
## dbGetQuery(conn, "select * from censo2010.lifetables") %>% View

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

paa2022_raw <- svytable(
  formula=~c008 + # age at interview date
    g058 +        # level of hearing impairment
    g057 +        # level of hearing impairment (despite use of hearing devices)
    c006 +        # sex 
    g05801 +      # use of Libras, the Brazilian sign language
    q092 +        # ever diagnosed with depression by a physician
    q11006,       # ever diagnosed with anxiety by a physician
  design = pns2019_posterior,
)

AGE_BREAKS <- c( 0, 1, seq(from=5,to=90, by=5), 1e3)
AGE_LABELS <- c('<1','1-4','5-9','10-14','15-19','20-24','25-29','30-34'
                ,'35-39','40-44','45-49','50-54','55-59','60-64','65-69'
                ,'70-74','75-79','80-84','85-89','90+')

paa2022_pns <- paa2022_raw %>% 
  as.data.frame(stringsAsFactors = FALSE) %>%
  mutate(
    c008 = as.numeric(c008),
    sex = factor( c006, levels = 1:2, labels = c('male', 'female')),
    libras = factor( g05801, levels = 1:2, labels = c('yes', 'no')),
    age_grp = cut( 
      c008, 
      breaks = AGE_BREAKS,
      labels = AGE_LABELS,
      include.lowest = TRUE,
      right = FALSE
    ),
    combined = case_when(
      g057 == ' ' ~ g058,
      g058 == ' ' ~ g057,
    ),
    hearing_impairment_level = case_when(
      combined %in% c('3', '4') ~ 'Heavily or Fully impaired',
      combined %in% c('1', '2') ~ 'Not or mildly impaired',
      # TRUE ~ 'Ignored or missing information'
    ),
    hearing_impaired = case_when(
      combined == '4' ~ 'Fully impaired',
      combined == '3' ~ 'Heavily impaired',
      combined == '2' ~ 'Mildly impaired',
      combined == '1' ~ 'Not impaired',
      # TRUE ~ 'Ignored or missing information'
    ),
    diagnosed_depression = q092,
    diagnosed_anxiety = q11006,
  ) 
  
summary_aux <- paa2022_pns %>% 
  filter( c008 >= 5, c008 <= 40 ) %>%
  group_by(combined, hearing_impaired, libras, diagnosed_depression) %>%
  summarise( n = sum(Freq))
  
summary_depr_libras <- summary_aux %>%
  group_by(combined, hearing_impaired, libras) %>%
  summarise( n = sum(n)) %>%
  na.omit() %>%
  pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>%
  mutate( pct_libras_users = yes / (yes+no)) %>%
  select( -c(yes,no)) %>%
  left_join( summary_aux %>% 
               group_by(combined, hearing_impaired, diagnosed_depression) %>% 
               summarise( n = sum(n)) %>%
               na.omit() %>% 
               pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>% 
               mutate( pct_depression = `1` / (`1`+`2`)) %>% 
               select( -c(3:5)) 
             ) %>%
  left_join( summary_aux %>% 
               filter( libras == 'yes') %>% 
               group_by(combined, hearing_impaired, diagnosed_depression) %>% 
               summarise( n = sum(n)) %>% 
               na.omit() %>% 
               pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>% 
               mutate( pct_depression_among_libras_users = `1` / (`1`+`2`)) %>%
               select( -c(3:5)) 
             ) 

summary_depr_libras %>% 
  ungroup() %>%
  select(-1) %>%
  write_csv2( 'libras_depression_summary_table.csv')

sum(paa2022_pns$Freq)  # estimated brazilian population in 2019

# Exploratory Data Analysis

# ever diagnosed with depression by a physician (g058)
depr_by_impairment <- paa2022_pns %>%
  na.omit() %>%
  group_by( hearing_impairment_level, age_grp, sex, diagnosed_depression) %>%
  summarise( n = sum( Freq ) ) %>%
  filter( diagnosed_depression != ' ') %>%
  pivot_wider( id_cols = c(1,2,3), names_from = 4, values_from = n) %>% 
  rename( yes = `1`, no = `2`) 

depr_by_impairment <- bind_rows(
  depr_by_impairment,
  depr_by_impairment %>% 
  group_by( hearing_impairment_level, age_grp) %>%
  summarise( yes = sum(yes), no = sum(no)) %>%
  transmute( hearing_impairment_level, age_grp, sex = 'both', yes, no)
) %>% mutate(
    pct = ifelse( yes+no== 0, 0, yes / (yes + no))
  ) 

depr_by_impairment %>% 
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  ggplot( aes( x = age_grp, y=pct*100, group = hearing_impairment_level, colour = hearing_impairment_level)) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    #,title = 'Depression prevalence'
    #,subtitle = 'Comparison by age band among levels of hearing impairment'
    ,caption='Source: weighted post-stratified survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) + 
  facet_wrap(~sex, ncol=3)

# ever diagnosed with anxiety by a physician (q11006)
anx_by_impairment <- paa2022_pns %>%
  na.omit() %>%
  group_by( hearing_impairment_level, age_grp, sex, diagnosed_anxiety) %>%
  summarise( n = sum( Freq ) ) %>%
  filter( diagnosed_anxiety != ' ') %>%
  pivot_wider( id_cols = c(1,2,3), names_from = 4, values_from = n) %>% 
  rename( yes = `1`, no = `2`) 

anx_by_impairment <- bind_rows(
  anx_by_impairment,
  anx_by_impairment %>% 
    group_by( hearing_impairment_level, age_grp) %>%
    summarise( yes = sum(yes), no = sum(no)) %>%
    transmute( hearing_impairment_level, age_grp, sex = 'both', yes, no)
) %>% mutate(
  pct = ifelse( yes+no== 0, 0, yes / (yes + no))
) 

anx_by_impairment %>% 
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  ggplot( aes( x = age_grp, y=pct*100, group = hearing_impairment_level, colour = hearing_impairment_level)) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    #,title = 'Anxiety prevalence'
    #,subtitle = 'Comparison by age band among levels of hearing impairment'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) +
  facet_wrap(~sex, ncol=3)

prevalences <- bind_rows(
  depr_by_impairment %>%
  mutate( disease = 'depression'),
  anx_by_impairment %>%
  mutate( disease = 'anxiety') ) 

dfle <- prevalences %>% 
  transmute(disease, sex, hearing_impairment_level, age_grp, pix = pct) %>%
  arrange( disease, sex,hearing_impairment_level, desc(age_grp) ) %>% 
  na.omit() %>%
  left_join(censo2010, by = c('age_grp','sex')) %>% 
  mutate( aux = (1-pix)*Lxn ) %>% 
  group_by(disease, sex, hearing_impairment_level) %>%
  mutate( 
    dfle = cumsum(aux)/lx, 
    age_grp = factor( age_grp, levels = AGE_LABELS),
    dfle_over_Ex = dfle / Ex
    ) %>% 
  select( -aux ) %>% 
  arrange( disease, sex, hearing_impairment_level, age_grp ) 

dfle_plot <- dfle %>%
  filter( disease == 'depression') %>% 
  ggplot( aes( x = age_grp ) ) + 
  geom_hline( yintercept = 1, linetype = 5) + 
  geom_line( aes( group = hearing_impairment_level, linetype = hearing_impairment_level, y = dfle_over_Ex )) + 
  labs(
    y = '[Disease-free Life Expectancy] / [Life Expectancy]',
    x = 'Quinquennial age group',
    linetype = 'Hearing impairment level'
  ) +
  ylim( 0.6, 1) +
  theme( legend.position = 'top', axis.text.x = element_text(angle = 90) ) +
  facet_wrap( ~ sex, nrow=1)

ggsave( plot = dfle_plot, filename = 'dfle_over_ex.png', width=10, height=5)

prevalences %>% 
  write_csv2('prevalences.csv')

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
  filter( g05801 == '1', c008 >= 5 & c008 <= 40 ) %>%     # only users of Libras
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

summary_aux <- paa2022_pns %>% 
  mutate( combined = g058) %>%
  filter( c008 >= 5, c008 <= 40, combined != ' ' ) %>%
  group_by(combined, hearing_impaired, libras, diagnosed_depression) %>%
  summarise( n = sum(Freq))

summary_depr_libras <- summary_aux %>%
  group_by(combined, hearing_impaired, libras) %>%
  summarise( n = sum(n)) %>%
  na.omit() %>%
  pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>%
  mutate( pct_libras_users = yes / (yes+no)) %>%
  select( -c(yes,no)) %>%
  left_join( summary_aux %>% 
               group_by(combined, hearing_impaired, diagnosed_depression) %>% 
               summarise( n = sum(n)) %>%
               na.omit() %>% 
               pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>% 
               mutate( pct_depression = `1` / (`1`+`2`)) %>% 
               select( -c(3:5)) 
  ) %>%
  left_join( summary_aux %>% 
               filter( libras == 'yes') %>% 
               group_by(combined, hearing_impaired, diagnosed_depression) %>% 
               summarise( n = sum(n)) %>% 
               na.omit() %>% 
               pivot_wider(id_cols = c(1,2), names_from = 3, values_from=4) %>% 
               mutate( pct_depression_among_libras_users = `1` / (`1`+`2`)) %>%
               select( -c(3:5)) 
  ) 

  
# among users of Libras
# ever diagnosed with depression by a physician (g058)
depr_libras <- paa2022_pns %>% 
  filter( g05801 == '1', combined %in% c('2','3','4') ) %>% # only users of Libras with at least some hearing impairment
  group_by( age_grp, sex, diagnosed_depression) %>%
  summarise( n = sum( Freq ) ) %>% 
  filter( diagnosed_depression != ' ') %>%
  pivot_wider( id_cols = c(1,2), names_from = 3, values_from = n ) %>% 
  rename( yes = `1`, no = `2`)

depr_libras <- bind_rows(
  depr_libras,
  depr_libras %>%
    group_by(age_grp) %>%
    summarise( yes = sum(yes), no = sum(no)) %>%
    transmute( age_grp, sex = 'both', yes, no)
  ) %>%
  mutate( pct = ifelse( yes+no== 0, 0, yes / (yes + no)) ) 

depr_libras %>% 
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  ggplot( aes( x = age_grp, 
               y=pct*1e2, 
               group = sex, 
               colour = sex
               )
          ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    ,title = 'Depression prevalence among users of Brazilian Sign Language'
    ,subtitle = 'Comparison by 5-year age band and sex'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) 

# among users of Libras
# ever diagnosed with anxiety by a physician (q11006)
anx_libras <- paa2022_pns %>% 
  filter( g05801 == '1', combined %in% c('2','3','4') ) %>% # only users of Libras with at least some hearing impairment
  group_by( age_grp, sex, diagnosed_anxiety) %>%
  summarise( n = sum( Freq ) ) %>% 
  filter( diagnosed_anxiety != ' ') %>%
  pivot_wider( id_cols = c(1,2), names_from = 3, values_from = n ) %>% 
  rename( yes = `1`, no = `2`)

anx_libras <- bind_rows(
  anx_libras,
  anx_libras %>%
    group_by(age_grp) %>%
    summarise( yes = sum(yes), no = sum(no)) %>%
    transmute( age_grp, sex = 'both', yes, no)
) %>%
  mutate( pct = ifelse( yes+no== 0, 0, yes / (yes + no)) ) 

anx_libras %>% 
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  ggplot( aes( x = age_grp, 
               y=pct*1e2, 
               group = sex, 
               colour = sex
  )
  ) + 
  geom_point() + geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    ,title = 'Anxiety prevalence among users of Brazilian Sign Language'
    ,subtitle = 'Comparison by 5-year age band and sex'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) 

# Depression (diagnosed by a physician)
# Comparison between users and not users of Libras
depr_compr <- paa2022_pns %>% 
  group_by( age_grp, sex, libras, diagnosed_depression) %>%
  summarise( n = sum( Freq ) ) %>% 
  filter( diagnosed_depression != ' ') %>%
  pivot_wider( id_cols = c(1,2,3), names_from = 4, values_from = n ) %>% 
  rename( yes = `1`, no = `2`)
                 
depr_compr <- bind_rows(
  depr_compr,
  depr_compr %>%
    group_by( age_grp, libras) %>%
    summarise( yes = sum(yes), no = sum(no)) %>%
    transmute( age_grp, sex = 'both', libras, yes, no)
) %>%               
  mutate( pct = ifelse( yes + no == 0, 0, yes / (yes + no)) )

depr_compr %>% 
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  na.omit() %>%
  ggplot( 
    aes( x = age_grp, 
               y=pct*1e2, 
               group = libras, 
               colour = libras
    )
  ) + 
  geom_point() + 
  geom_line()+
  labs(
    y = '% of people diagnosed with depression by a physician'
    ,x = '5-year age band'
    ,title = 'Depression prevalence'
    ,subtitle = 'Comparison by 5-year age band, sex and knowledge of Brazilian Sign Language'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group ='knows brazilian sign language (Libras)'
    ,colour='knows brazilian sign language (Libras)'
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) + 
  facet_wrap(~sex)


# Anxiety (diagnosed by a physician)
# Comparison between users and not users of Libras
anx_compr <- paa2022_pns %>% 
  group_by( age_grp, sex, libras, diagnosed_anxiety) %>%
  summarise( n = sum( Freq ) ) %>% 
  filter( diagnosed_anxiety != ' ') %>%
  pivot_wider( id_cols = c(1,2,3), names_from = 4, values_from = n ) %>% 
  rename( yes = `1`, no = `2`)

anx_compr <- bind_rows(
  anx_compr,
  anx_compr %>%
    group_by( age_grp, libras) %>%
    summarise( yes = sum(yes), no = sum(no)) %>%
    transmute( age_grp, sex = 'both', libras, yes, no)
) %>%               
  mutate( pct = ifelse( yes + no == 0, 0, yes / (yes + no)) )

anx_compr %>% 
  na.omit() %>%
  filter( !age_grp %in% c('<1','1-4','5-9')) %>%
  ggplot( 
    aes( x = age_grp, 
         y=pct*1e2, 
         group = libras, 
         colour = libras
    )
  ) + 
  geom_point() + 
  geom_line()+
  labs(
    y = '% of people diagnosed with anxiety by a physician'
    ,x = '5-year age band'
    ,title = 'Anxiety prevalence'
    ,subtitle = 'Comparison by 5-year age band, sex and knowledge of Brazilian Sign Language'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group ='knows brazilian sign language (Libras)'
    ,colour='knows brazilian sign language (Libras)'
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) + 
  facet_wrap(~sex)

# hearing impairment prevalence by sex and 5-year age band
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
  group_by( sex, age_grp, hearing_impairment_level) %>%
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
    ,subtitle = 'Comparison by 5-year age band among levels of hearing impairment and sex'
    ,caption='Source: weighted survey data from National Health Survey (PNS 2019/IBGE)'
    ,group =''
    ,colour=''
  ) + 
  theme(
    legend.position = 'top'
    ,axis.text.x = element_text(angle = 90)
  ) + 
  facet_wrap(~sex, ncol=4,scales = 'free_y')

# srvyr, if needed ...
#poststr <- data_posterior %>% as_survey()
#matr <- poststr %>%
#  filter( age == 15 ) %>%
#  group_by(sex, hearing_impairment_level, brazilian_sign_language_use) %>%
#  summarise( n = survey_total())


# ideia validada com luciana em 06.09.2022
# prevalencia de depressao por (1) grau de dificuldade em ouvir, (2) idade quinquenal e (3) sexo
# usar tabua abreviada do censo 2010


# restringir a alguns graus de dificuldade de ouvir 
# separar em (1) usa libras, (2) sexo e (3) idade quinquenal
# calcular prevalência de depressão
# usar tabua abreviada do censo 2010

