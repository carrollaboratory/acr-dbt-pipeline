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

# --------------------------------------------------
# Get unique registered_identifiers
r <- execute(
  "SELECT distinct registered_identifier
  FROM main_cmg.cmg_main_anvil_dataset s
")
print(r)
# consent_group
# 1            HMB-IRB
# 2            GRU-IRB
# 3            DS-NBIA
# 4              DS-MC
# 5          DS-BPEAKD
# 6           DS-CHDEF
# 7  DS-BAV-IRB-PUB-RD
# 8                HMB
# 9           DS-RARED
# 10       DS-THAL-IRB
# 11           HMB-GSO
# 12             DS-EP
# 13               GRU
# 14             DS-RD
# 15            DS-HFA
# 16           DS-BDIS

# --------------------------------------------------

# Link anvil_dataset metadata to other src data
# Can anvil_dataset.registered_identifier be linked to a person_id - stb person harmonization
# Using dataset_id?


r <- execute(
  "SELECT distinct source_snapshot, dbgap_submission, dbgap_study_id, multiple_datasets, ad.* 
  FROM main_cmg.cmg_main_subject s
  left join main_cmg.cmg_main_anvil_dataset ad
  using(source_snapshot_id , source_snapshot)

")

print(r)

# information schema ------------------------------------------

table_names <- execute(
  "SELECT * FROM information_schema.tables 
   WHERE (table_name like '%cmg_main%')"
)

print(table_names)

# ------------------------------------------

table_metadata <- execute(
  "SELECT table_name, COUNT(*) AS ncols
   FROM information_schema.columns
   WHERE table_schema = 'main_cmg'
   AND table_name like '%subject%'
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





# Which datasets have non-null columns ----------------------------------------


columns <- execute("
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'main_cmg'
      AND table_name = 'cmg_main_subject'
    ORDER BY column_name
")$column_name

column_exprs <- paste(
  sprintf(
    'MAX(CASE WHEN "%s" IS NOT NULL THEN 1 ELSE 0 END) AS "%s"',
    columns, columns
  ),
  collapse = ",\n    "
)

query <- sprintf('
    SELECT
        ingest_provenance,
        %s
    FROM "main_cmg"."cmg_main_subject"
    GROUP BY ingest_provenance
    ORDER BY ingest_provenance
', column_exprs)

result <- execute(query)
print(result)




# n unique values across all datasets ----------------------------------------

columns <- execute("
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'main_cmg'
      AND table_name = 'cmg_main_subject'
    ORDER BY column_name
")$column_name

count_exprs <- paste(
  sprintf('COUNT(DISTINCT "%s") AS "%s"', columns, columns),
  collapse = ",\n    "
)

query <- sprintf('
    SELECT %s
    FROM "main_cmg"."cmg_main_subject"
', count_exprs)

result <- execute(query)
print(result)


# n unique values group by dataset ----------------------------------------

columns <- execute("
    SELECT column_name
    FROM information_schema.columns
    WHERE table_schema = 'main_cmg'
      AND table_name = 'cmg_main_workspace_attributes'
      AND column_name <> 'ingest_provenance'
    ORDER BY column_name
")$column_name

count_exprs <- paste(
  sprintf('COUNT(DISTINCT "%s") AS "%s"', columns, columns),
  collapse = ",\n    "
)

query <- sprintf('
    SELECT
        ingest_provenance,
        %s
    FROM "main_cmg"."cmg_main_workspace_attributes"
    GROUP BY ingest_provenance
    ORDER BY ingest_provenance
', count_exprs)

result <- execute(query)
print(result)

write.csv(
  result,
  "~/pipelines/data/analysis/cmg_main_workspace_attributes_unique_counts_groupby_ds.csv",
  row.names = FALSE
)