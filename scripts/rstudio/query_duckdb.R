# ============================================================================
# Tool to query tables in the duckdb database.
# ============================================================================


if(!require("duckdb")) install.packages("duckdb")
if(!require("DBI")) install.packages("DBI")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("openxlsx")) install.packages("openxlsx")

library(duckdb)
library(DBI)
library(tidyverse)
library(openxlsx)


bucket <- Sys.getenv("WORKSPACE_BUCKET")
if (bucket == "") {
  bucket <- "bucket_placeholder"
}


drv <- duckdb(dbdir = "~/pipelines/data/acr_dbt_pipeline.duckdb")
con <- dbConnect(drv)
# dbDisconnect(con)

execute <- function(query) {
  result <- dbGetQuery(con, query)
  return(result)
}

# Analysis ------------------------------------------

table_names <- execute(
  "SELECT * FROM information_schema.tables 
   WHERE (table_name like '%src%' OR table_name like '%int%')"
)

print(table_names)

# ------------------------------------------

table_metadata <- execute(
  "SELECT table_name, COUNT(*) AS ncols
   FROM information_schema.columns
   WHERE table_schema = 'main_cmg'
   GROUP BY table_name"
)

shapes_list <- list()

for (t in table_metadata$table_name) {
  row_query <- sprintf(
    'SELECT COUNT(*) AS nrows FROM "%s"."%s"',
    "main_cmg",
    t
  )
  
  nrows <- execute(row_query)$nrows[1]
  
  ncols <- table_metadata$ncols[table_metadata$table_name == t]
  
  shapes_list[[length(shapes_list) + 1]] <- data.frame(
    table_name = t,
    nrows = nrows,
    ncols = ncols,
    stringsAsFactors = FALSE
  )
}

shapes <- do.call(rbind, shapes_list)
print(shapes)
