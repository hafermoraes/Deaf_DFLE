#!/bin/bash

# shell script configs
set -eu

echo "=life_tables= preparation scripts for de-mpidr-hld\n"

# url where 2019th edition of brazilian life tables are located
lt_url=https://www.lifetable.de/File/GetDocument/data/BRA/BRA000020192019CU1.txt

# source and directories where raw and processed data are to be stored
src_dir=/tmp/etl/de_mpidr_hld
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
    R --quiet --vanilla -e "curl::curl_download( '${lt_url}', '${raw_data}/lt2019.txt' )"

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
