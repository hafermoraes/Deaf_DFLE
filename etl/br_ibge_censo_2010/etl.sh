#!/bin/bash

# shell script configs
set -eu

echo "=life_tables= preparation scripts for br-ibge-censo-2010\n"

# url where 2010th edition of brazilian life tables are located
lt_url=ftp://ftp.ibge.gov.br/Tabuas_Abreviadas_de_Mortalidade/2010/tabelas_xls.zip

# source and directories where raw and processed data are to be stored
src_dir=/tmp/etl/br_ibge_censo_2010
raw_data=${src_dir}/raw
proc_data=${src_dir}/data

create_temporary_directories(){

    echo "Creating temporary directory for raw data at $raw_data..."
    rm -rf ${raw_data}
    mkdir -p ${raw_data}

    echo "DONE.\nCreating temporary directory for processed data at $proc_data..."
    rm -rf ${proc_data}
    mkdir -p ${proc_data}

    echo "DONE."
}

fetch_life_tables(){

    echo "Fetching the =life-tables= from $lt_url..."
    R --quiet --vanilla -e "curl::curl_download( '${lt_url}', '${raw_data}/lt.zip' )"

    echo '  DONE. Unziping the =life-tables=...'
    unzip ${raw_data}/lt.zip -d ${raw_data}

    echo '  DONE. Deleting the downloaded =microdata= zip file...'
    rm -rf ${raw_data}/lt.zip
    echo 'DONE.'

}

parse_life_tables_using_GNU_R(){

    echo 'Parsing the life tables using GNU R'
    R CMD BATCH --quiet --vanilla ./gnur_parse_life_tables.R
    rm *.Rout

    echo 'DONE.'
}

remove_temporary_steps(){

    echo "Removing the temporary intermediate files"
    rm -rf ${raw_data}
    echo "DONE."
}

main(){

    create_temporary_directories

    fetch_life_tables

    parse_life_tables_using_GNU_R

    remove_temporary_steps

}

main

exit 0
