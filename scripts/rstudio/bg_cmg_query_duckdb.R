# ============================================================================
# Tool to query tables in the duckdb database.
# ============================================================================


if(!require("duckdb")) install.packages("duckdb")
if(!require("DBI")) install.packages("DBI")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("openxlsx")) install.packages("openxlsx")
if(!require("knitr")) install.packages("knitr")
library(duckdb)
library(DBI)
library(tidyverse)
library(openxlsx)
library(knitr)


bucket <- Sys.getenv("WORKSPACE_BUCKET")
if (bucket == "") {
  bucket <- "bucket_placeholder"
}

drv <- duckdb(dbdir = "~/pipelines/data/acr_dbt_pipeline.duckdb")
con <- dbConnect(drv)
# dbDisconnect(con)

execute <- function(query, max_rows = 50, max_width = 20, format = "rst") {
  result <- dbGetQuery(con, query)
  total_rows <- nrow(result)
  if (total_rows == 0) {
    message("Query executed successfully, but returned 0 rows.")
    return(invisible(result))
  }
  preview <- head(result, max_rows)
  for (col_name in names(preview)) {
    txt <- as.character(preview[[col_name]])
    too_long <- !is.na(txt) & nchar(txt) > max_width
    txt[too_long] <- paste0(substr(txt[too_long], 1, max_width - 3), "...")
    preview[[col_name]] <- txt
  }
  summary_line <- sprintf("\nShowing %d of %d available rows.", nrow(preview), total_rows)
  output <- c(as.character(kable(preview, format = format)), summary_line)
  if (interactive() && isatty(stdout()) && nzchar(Sys.which("less"))) {
    p <- pipe("less -S", "w")
    writeLines(output, p)
    close(p)
  } else {
    cat(output, sep = "\n")
  }
  invisible(result)
}


# Print a result as a Markdown table. In Google Docs paste with
# Edit > Paste from Markdown (enable it in Tools > Preferences first).
print_table <- function(df) {
  cells <- as.data.frame(lapply(df, function(x) gsub("|", "\\|", as.character(x), fixed = TRUE)))
  cells[is.na(cells)] <- "NULL"
  row_line <- function(x) paste0("| ", paste(x, collapse = " | "), " |")
  cat(row_line(names(df)), row_line(rep("---", ncol(df))),
      apply(cells, 1, row_line), sep = "\n")
  invisible(df)
}

# Write a result to CSV (default ~/pipelines/data/analysis/r_query_result.csv)
# and print the path. Rename with file= and/or dir=.
save_csv <- function(df, file = "r_query_result.csv", dir = "~/pipelines/data/analysis") {
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(path.expand(dir), file)
  write.csv(df, path, row.names = FALSE, na = "")
  message("Wrote ", nrow(df), " rows to ", path)
  invisible(path)
}

# Usage:
#   r <- execute("select ...")
#   print_table(r)                                  # copy into a Google Doc
#   save_csv(r)                                     # default file
#   save_csv(r, "yale_gru_files.csv", dir = "~/pipelines/data/analysis/cmg")


# Example query with valid SQL syntax
r <- execute("
  SELECT *
  FROM main_cmg.cmg_main_family s
  WHERE pedigree_detail IS NOT NULL
  LIMIT 50
")

# Analysis ------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# --------------------------------------------------
# Files with no sample link, by snapshot and file extension
r <- execute("
select source_snapshot, full_extension,
       count(*) as n_files,
       count(*) filter (where sample_id is null) as n_unlinked
from main_cmg.cmg_int_file_inventory
group by all
having count(*) filter (where sample_id is null) > 0
order by source_snapshot, n_unlinked desc
")

# --------------------------------------------------
# Count files repeated in cmg_int_file_inventory, by number of linked samples
r <- execute("
select source_snapshot, n_rows as samples_per_file, count(*) as n_files,
       string_agg(distinct full_extension, ', ') as extensions
from (
  select source_snapshot, any_value(full_extension) as full_extension, count(*) as n_rows
  from main_cmg.cmg_int_file_inventory
  group by file_id, source_snapshot
  having count(*) > 1
)
group by all
order by 1
")




# --------------------------------------------------

r <- execute("
select count(distinct sa.sample_id) as orphan_samples,
       count(sq.sequencing_id) as sequencing_rows_lost
from main_cmg.cmg_int_sample sa
left join main_cmg.cmg_int_sequencing sq
  using (sample_id, source_snapshot_id)
where sa.source_snapshot = 'cmg_yale_ds_mc'
  and sa.subject_gid is null
")


# ------------------------------------------
# Example query
r <- execute("
select source_snapshot, file_ref, file_id,
       count(*) as n_rows,
       string_agg(distinct sample_id, ', ') as sample_ids,
       string_agg(distinct subject_id, ', ') as subject_ids,
       count(sequencing_id) as n_seq_links
from main_cmg.cmg_int_file_inventory
group by all
having count(*) > 1
order by n_rows desc
limit 50
")


# ------------------------------------------
# Example query
r <- execute("
with m as (
  select source_snapshot, count(*) as main_rows
  from main_cmg.cmg_main_file_inventory
  group by all
),
i as (
  select source_snapshot, count(*) as int_rows,
         count(*) filter (where sample_id is null) as unlinked_rows
  from main_cmg.cmg_int_file_inventory
  group by all
)
select 'file_inventory' as domain, m.source_snapshot, main_rows, int_rows,
       int_rows - main_rows as extra_rows, unlinked_rows
from m left join i using (source_snapshot)
order by extra_rows desc, m.source_snapshot
")


# --------------------------------------------------
# Get unique registered_identifiers
r <- execute("
with refs as (
  select source_snapshot, source_snapshot_id, 'cram' as ref_column, sample_id as owner_id, cast(cram as varchar) as ref_value
  from main_cmg.cmg_main_sample where cram is not null
  union all
  select source_snapshot, source_snapshot_id, 'crai', sample_id, cast(crai as varchar)
  from main_cmg.cmg_main_sample where crai is not null
  union all
  select source_snapshot, source_snapshot_id, 'bam', sample_id, cast(bam as varchar)
  from main_cmg.cmg_main_sample where bam is not null
  union all
  select source_snapshot, source_snapshot_id, 'sequencing_id_fileref', sequencing_id, cast(sequencing_id_fileref as varchar)
  from main_cmg.cmg_main_sequencing where sequencing_id_fileref is not null
  union all
  select source_snapshot, source_snapshot_id, 'seq_filename', sequencing_id, cast(seq_filename as varchar)
  from main_cmg.cmg_main_sequencing where seq_filename is not null
  union all
  select source_snapshot, source_snapshot_id, 'file_id', sequencing_id, cast(file_id as varchar)
  from main_cmg.cmg_main_sequencing where file_id is not null
),
inventory as (
  select source_snapshot_id, file_id as inv_file_id, 'file_ref' as inventory_key, cast(file_ref as varchar) as key_value
  from main_cmg.cmg_main_file_inventory where file_ref is not null
  union all
  select source_snapshot_id, file_id, 'file_id', cast(file_id as varchar)
  from main_cmg.cmg_main_file_inventory where file_id is not null
  union all
  select source_snapshot_id, file_id, 'uri', cast(uri as varchar)
  from main_cmg.cmg_main_file_inventory where uri is not null
  union all
  select source_snapshot_id, file_id, 'name', cast(name as varchar)
  from main_cmg.cmg_main_file_inventory where name is not null
  union all
  select source_snapshot_id, file_id, 'path', cast(path as varchar)
  from main_cmg.cmg_main_file_inventory where path is not null
),
matches as (
  select r.*, i.inventory_key, i.inv_file_id
  from refs r
  left join inventory i
    on i.source_snapshot_id = r.source_snapshot_id
   and i.key_value = r.ref_value
),
per_ref as (
  select source_snapshot, ref_column, inventory_key, ref_value,
         count(distinct inv_file_id) as n_files
  from matches
  group by all
),
per_file as (
  select source_snapshot, ref_column, inventory_key,
         count(*) as n_files_matched,
         max(n_owners) as max_refs_per_file
  from (
    select source_snapshot, ref_column, inventory_key, inv_file_id,
           count(distinct owner_id) as n_owners
    from matches
    where inv_file_id is not null
    group by all
  )
  group by all
),
n_refs as (
  select source_snapshot, ref_column, count(distinct ref_value) as n_refs
  from refs
  group by all
)
select
  p.source_snapshot,
  p.ref_column,
  p.inventory_key,
  n.n_refs,
  count(distinct p.ref_value) filter (where p.n_files > 0) as n_refs_matched,
  f.n_files_matched,
  max(p.n_files) as max_files_per_ref,
  f.max_refs_per_file
from per_ref p
join n_refs n
  on n.source_snapshot = p.source_snapshot and n.ref_column = p.ref_column
left join per_file f
  on f.source_snapshot = p.source_snapshot
 and f.ref_column = p.ref_column
 and f.inventory_key is not distinct from p.inventory_key
group by all
order by p.source_snapshot, p.ref_column, p.inventory_key nulls last
")




# --------------------------------------------------
# Get unique registered_identifiers
r <- execute(
  "
 -- select source_snapshot, issue, count(*) as n_samples
--from ( 
with samples as (
  select distinct source_snapshot, source_snapshot_id, sample_id, subject_id
  from main_cmg.cmg_main_sample
),
subjects as (
  select distinct source_snapshot, source_snapshot_id, subject_id
  from main_cmg.cmg_main_subject
)

select
  sa.source_snapshot,
  sa.sample_id,
  sa.subject_id,
  case
    when sa.subject_id is null then 'null_subject_id'
    when other.subject_id is not null then 'subject_in_other_snapshot'
    else 'subject_missing'
  end as issue,
  string_agg(distinct other.source_snapshot, ', ') as subject_found_in_snapshots
from samples sa
left join subjects same
  on same.subject_id = sa.subject_id
  and same.source_snapshot_id = sa.source_snapshot_id
left join subjects other
  on other.subject_id = sa.subject_id
  and other.source_snapshot_id <> sa.source_snapshot_id
where same.subject_id is null
group by all
order by sa.source_snapshot, issue, sa.sample_id

--)
--group by all
--order by 1, 2;
")

# --------------------------------------------------
# Dive into Family
r <- execute(
  "
select source_snapshot, count(*) as n_files_with_multiple_rows, max(n) as max_rows
from (
  select source_snapshot, file_id, count(*) as n
  from main_cmg.cmg_int_file_inventory
  group by all
  having count(*) > 1
)
group by all;
")


# --------------------------------------------------
# Dive into Family
r <- execute(
  "
with sa as (
  select sample_id, subject_id from main_cmg.cmg_main_sample
  where source_snapshot = 'cmg_yale_ds_mc'
),
sb as (
  select distinct subject_id from main_cmg.cmg_main_subject
  where source_snapshot = 'cmg_yale_ds_mc'
)
select
  (sb_match.subject_id is not null)   as joins_to_subject,
  (sa.sample_id = sa.subject_id)      as sample_eq_subject,
  count(*)                            as n_samples,
  count(*) filter (where exists (
    select 1 from sb
    where sa.sample_id like sb.subject_id || '%' and sa.sample_id <> sb.subject_id
  ))                                  as n_prefix_match
from sa
left join sb sb_match on sb_match.subject_id = sa.subject_id
group by all
order by 1, 2;
")



# --------------------------------------------------
# Dive into Family
r <- execute(
  "SELECT *
  FROM main_cmg.cmg_main_family s
  where pedigree_detail not null
  LIMIT 50
")

r <- execute(
  "SELECT *
  FROM cmg_int_family s
  where pedigree_detail not null
  LIMIT 50
")


# --------------------------------------------------
# Get unique registered_identifiers
r <- execute(
  "SELECT *
  FROM main_cmg.cmg_int_subject s
")

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


# information schema ------------------------------------------

table_names <- execute(
  "SELECT * FROM information_schema.tables 
   WHERE (table_name like '%cmg_main%')"
)


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

write.csv(
  result,
  "~/pipelines/data/analysis/cmg_main_workspace_attributes_unique_counts_groupby_ds.csv",
  row.names = FALSE
)