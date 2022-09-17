# for reproducibility...
# > sessionInfo()
# R version 4.2.1 (2022-06-23)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 20.04.5 LTS
# 
# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3
# 
# locale:
#   [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
# [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
# [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
# [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
# 
# attached base packages:
#   [1] grid      stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] survey_4.1-1   survival_3.3-1 Matrix_1.4-1   tidyr_1.2.0    dplyr_1.0.10   PNSIBGE_0.1.7 
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_1.0.9        cellranger_1.1.0  pillar_1.8.1      compiler_4.2.1    bitops_1.0-7     
# [6] RPostgres_1.4.4   tools_4.2.1       bit_4.0.4         lattice_0.20-45   lifecycle_1.0.1  
# [11] tibble_3.1.8      gtable_0.3.1      pkgconfig_2.0.3   rlang_1.0.5       DBI_1.1.3        
# [16] cli_3.3.0         rstudioapi_0.14   curl_4.3.2        withr_2.5.0       httr_1.4.4       
# [21] mitools_2.4       generics_0.1.3    vctrs_0.4.1       hms_1.1.2         bit64_4.0.5      
# [26] tidyselect_1.1.2  glue_1.6.2        R6_2.5.1          fansi_1.0.3       readxl_1.4.1     
# [31] vroom_1.5.7       projmgr_0.1.0     ggplot2_3.3.6     purrr_0.3.4       readr_2.1.2      
# [36] tzdb_0.3.0        blob_1.2.3        magrittr_2.0.3    scales_1.2.1      ellipsis_0.3.2   
# [41] splines_4.2.1     assertthat_0.2.1  timeDate_4021.104 colorspace_2.0-3  utf8_1.2.2       
# [46] RCurl_1.98-1.8    munsell_0.5.0     crayon_1.5.1    

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