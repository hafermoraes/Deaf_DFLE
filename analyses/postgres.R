#install.packages("RPostgreSQL")
#install.packages("RPostgres")

library(tidyverse)
library(DBI)
library(srvyr)
library(RPostgres)

conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("PG_DB"),
  host = Sys.getenv("PG_HOST"),
  port = Sys.getenv("PG_PORT"),
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD")
)

dbGetQuery(conn, "SELECT * FROM ed2019.microdata LIMIT 5") %>% View

dbGetQuery(conn, "SELECT * FROM ed2019.datadict") %>% View
