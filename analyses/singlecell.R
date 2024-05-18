# for reproducibility...
## > sessionInfo()
## R version 4.4.0 (2024-04-24)
## Platform: x86_64-pc-linux-gnu
## Running under: Linux Mint 21

## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0

## locale:
##  [1] LC_CTYPE=pt_BR.UTF-8       LC_NUMERIC=C
##  [3] LC_TIME=pt_BR.UTF-8        LC_COLLATE=pt_BR.UTF-8
##  [5] LC_MONETARY=pt_BR.UTF-8    LC_MESSAGES=pt_BR.UTF-8
##  [7] LC_PAPER=pt_BR.UTF-8       LC_NAME=C
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C
## [11] LC_MEASUREMENT=pt_BR.UTF-8 LC_IDENTIFICATION=C

## time zone: America/Sao_Paulo
## tzcode source: system (glibc)

## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base

## loaded via a namespace (and not attached):
## [1] compiler_4.4.0


# install.packages(c('PNSIBGE','survey','dplyr','tidyr'))
library(PNSIBGE)  # (version 0.1.7)  get_pns
library(survey)   # (version 4.1-1)  svytable
library(dplyr)    # (version 1.0.10) mutate, group_by, summarise, %>%
library(tidyr)    # (version 1.2.0)  pivot_wider

pns2019 <- PNSIBGE::get_pns(year=2019)

# reconciliation against
#   https://sidra.ibge.gov.br/tabela/7666#/n1/all/v/2667/p/all/c2/all/c12258/all/d/v2667%200/l/v,p+c2,t+c12258/resultado
round( svytable(formula=~J001+C006, design=subset(pns2019, C008 >=18))/1e3, 0) %>%
  as.data.frame() %>%
  mutate(
    tab7666 = case_when(
      grepl('bom',J001, ignore.case = TRUE) ~ 1,
      J001 == 'Regular' ~ 2,
      grepl('ruim',J001, ignore.case = TRUE) ~ 3,
    )
    ,tab7666 = factor( tab7666, levels = 1:3, labels = c('Muito ruim e ruim','Regular','Muito bom e bom'))
  ) %>%
  na.omit() %>%
  group_by(tab7666, C006) %>%
  summarise( n = sum(Freq) ) %>%
  pivot_wider(id_cols = tab7666, names_from = C006, values_from = n)

# # A tibble: 3 × 3
# # Groups:   tab7666 [3]
# tab7666             Homem Mulher
# <fct>               <dbl>  <dbl>
# 1 Muito ruim e ruim 53296  54574
# 2 Regular           17646  24349
# 3 Muito bom e bom    3610   5696

round( svytable(formula=~C006, design=subset(pns2019, C008 >= 18))/1e3, 0)
# C006
# Homem Mulher 
# 74553  84619

round( sum(svytable(formula=~C006, design=subset(pns2019, C008 >= 18)))/1e3, 0)
# [1] 159171
