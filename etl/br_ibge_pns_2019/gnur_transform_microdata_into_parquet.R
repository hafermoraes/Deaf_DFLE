## Converts microdata from text format to parquet using library(arrow)
library(arrow)  # open_dataset, write_dataset
library(readr)  # read_delim
library(purrr)  # map
library(dplyr)  # %>%, select

src_dir <- '/tmp/etl/br_ibge_pns_2019/'
raw_data <- paste0(src_dir, 'raw/')
proc_data <- paste0(src_dir, 'data/')
parq_data <- paste0(src_dir, 'parquet/')

col_names <-
  read_delim(
    file = paste0(proc_data, 'col_names.txt'),
    delim = '|',
    show_col_types = FALSE
  )
## adapted from https://stackoverflow.com/a/71305598
csv_schema <- schema(
  purrr::map( col_names$q_code, ~Field$create(name = .x, type = string()))
)

## reads comma delimited microdata using arrow package
microdata_pipe_delimited <-
  open_dataset(
    paste0(proc_data, 'microdata.txt'),
    format="csv",
    schema = csv_schema,
    col_names = TRUE,
    skip = 0
  )

## subset of variables used in the academic paper Deaf_DFLE
dfle_data <-
  microdata_pipe_delimited %>%
  select(
    ## survey design variables
    upa_pns, v0024, 
    v0028, v00281, v00282, v00283, # chosen respondent answers in the name of all persons of household
    ## variables for analyses
    j001,   # health_perception (for validation purposes only...)
    e001,   # work (for validation purposes only...)
    c006,   # gender
    c008,   # age
    q092,   # ever diagnosed with depression by a physician
    q11006, # ever diagnosed with anxiety by a physician
    g058,   # hearing impairment level
    g057,   # hearing impairment level even using hearning devices
    g05801, # knowdledge of Libras, the brazilian sign language
    v0015   # indicator for type of interview
  )

## saving microdata to disk in format 'parquet'
## for speed and smaller disk size
write_parquet(
  dfle_data, 
  sink = paste0(parq_data, 'microdata.parquet'),
  )
