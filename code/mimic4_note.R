#-------Packages--------------------------------------------------------------
# install.packages("RPostgres")
# install.packages("DBI")
# install.packages("dbplyr")
# install.packages('tidyverse')
# install.packages('dbplot')
# install.packages("skimr")
# install.packages("ggplot2")
#여러줄 주석은 ctrl+Shift+c
#rstudioapi::addTheme("https://raw.githubusercontent.com/dracula/rstudio/master/dracula.rstheme", apply = TRUE) #콘솔에서 설치
#-------Library--------------------------------------------------------------------

library(dplyr)
library(DBI)
library(readr)
library(dbplyr)
library(stringr)
library(readr)
library(tidyverse)
library(vroom)
library(lubridate)
library(dbplot)
library(skimr)
library(ggplot2)


#-------MIMIC4 note DB Conn--------------------------------------------------------------

host = "160.1.17.128"
port = "5432"
DB = "mimic4_note"
UserName = "bida" 

conn <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = DB,
  user = UserName,
  password = "bida1234$",
  host = host,
  port = port,
  bigint = "numeric"
)

#---------tables------------------------------------------------------------
#테이블리스트를 불러옴
Tables = dbGetQuery(conn,
                    "SELECT table_name, table_schema FROM information_schema.tables 
             where not table_schema = 'information_schema' and not table_schema = 'pg_catalog'") %>%
  arrange(table_schema, table_name) 

Tables

discharge <- dplyr::tbl(conn, dbplyr::in_schema("mimiciv_note", "discharge")) 
discharge_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimiciv_note", "discharge_detail")) 
radiology <- dplyr::tbl(conn, dbplyr::in_schema("mimiciv_note", "radiology")) 
radiology_detail <- dplyr::tbl(conn, dbplyr::in_schema("mimiciv_note", "radiology_detail")) 


#-----Analysis

discharge %>% view()
discharge_detail
