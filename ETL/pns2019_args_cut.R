
## bibliotecas de análise
library(dplyr)
library(readxl)
library(tidyr)
library(readr)
library(stringr)

## dicionário de dados
dict <- read_excel(
    path = '/tmp/dfle_pns/dicionario_PNS_microdados_2019.xls'
   ,sheet = 'dicionário pns'
   ,range = 'C6:G5224'
   ,col_names = FALSE
)

dict %>%
    select(1,3,4,5) %>%
    rename( var = 1, enun = 2, cod = 3, resp = 4) %>%
    fill( var, enun) %>%
    mutate(
        enun = str_replace_all( enun, '[\r\n\"\\"]', '')
    ) %>%
    write_delim( '/tmp/dfle_pns/pg_pns2019_vars', delim='|', quote = 'none', col_names = FALSE)


## enunciados por questão
enuns <- dict %>%
    select(1,3) %>%
    rename( var = 1, enun = 2) %>%
    na.omit() %>%
    distinct() %>%
    mutate(
        enun = str_replace_all( enun, '[\r\n\"\\"]', '')
    )

## colunas dos microdados
fs <- read_delim(
    '/tmp/dfle_pns/input_PNS_2019.sas'
   ,delim = '\t'
   ,skip = 10
   ,col_names=FALSE
)

fs <- fs %>%
    head(-2) %>% # ignora últimas duas linhas
    select(1,2,3) %>% # seleciona somente as primeiras 3 colunas
    rename( from = 1, var = 2, len = 3 ) %>% # renomeia as colunas
    mutate(
        from = as.numeric( str_extract( from, '\\d+' ) ) # regex para extrair números somente
       ,len = as.numeric( str_extract( len, '\\d+' ) )
       ,arg_cut = paste0(from,'-',from + (len -1) ) # intervalo de colunas para 'cut'
    ) %>%
    left_join( enuns, by=c('var'='var') ) %>%
    transmute(
        var
       ,from
       ,len
       ,arg_cut
       ,wording = enun
       ,pg_create_table = paste( var, 'text,')
       ,comments = paste0(
            '# '
           ,str_pad(string = var, width = 12, pad =' ', side = 'right')
           ,str_pad(string = arg_cut, width = 10, pad =' ', side = 'right')
           ,str_pad(string = paste0('(',len,')'), width = 6, pad =' ', side = 'right')
           ,enun
        )
    ) 

## exporta intervalos de coluna argumento -c do comando 'cut' a ser usado no terminal
paste0( fs$arg_cut, collapse = ',') %>%
    write_file( '/tmp/dfle_pns/arg_cut')

## exporta dicionário de dados tratados como comentários para bash script que
## converte microdados de tamanho fixo para arquivo delimitado
fs %>%
    select(comments) %>%
    write_delim( '/tmp/dfle_pns/comments', delim='', quote = 'none')

## exporta corpo da query de criação da tabela no postgres
fs %>%
    select( pg_create_table ) %>%
    write_delim( '/tmp/dfle_pns/pg_pns2019_createtable', delim='', quote = 'none', col_names = FALSE)
    
