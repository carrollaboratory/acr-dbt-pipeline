# Data profiling: analyses and macros

Tools for answering questions like:

- Which datasets fill in which columns?
- Is this column unique? How many distinct values does it have?
- Does each `subject_id` belong to exactly one `family_id`?
- If I `left join` table A to table B, will I lose rows or duplicate them?

There are two kinds of tool:

| Tool | What it does | Where |
| --- | --- | --- |
| Profiling macros | Generate a `SELECT` query. Nothing is written to the database. | [`macros/ad_hoc/profiling.sql`](../macros/ad_hoc/profiling.sql) |
| `store_profile` | Profiles every column of a table and **saves** the result to a `profile_<table>` table, keeping history. | [`macros/ad_hoc/store_profile.sql`](../macros/ad_hoc/store_profile.sql) |

The macros are local copies originally sourced from dbt_pipeline_utils; call
them without a namespace (`profile_...`). Ready-made examples for the CMG tables are in [`cmg/profiling/`](cmg/profiling/).

> **Before you start:** the tables you profile must already be built (`dbt run`).
> The macros look up column names in the database, so they can't run against
> tables that don't exist yet.

---

## 1. How to run a profiling query

Run every `dbt` command from the `acr_dbt_pipeline/` directory.

### Option A: edit an example analysis file and compile it

1. Open a file in `analysis/cmg/profiling/` and change the table name or options.
2. Compile it:

   ```bash
   dbt compile -s cmg_profile_column_presence
   ```

3. The finished SQL is written to
   `target/compiled/acr_dbt_pipeline/analysis/cmg/profiling/cmg_profile_column_presence.sql`.
   Run it in R:

   ```r
   path <- "target/compiled/acr_dbt_pipeline/analysis/cmg/profiling/cmg_profile_column_presence.sql"
   result <- execute(paste(readLines(path), collapse = "\n"))
   print(result)
   ```

### Option B: a one-off query without a file

`dbt show` runs the query and prints the first rows:

```bash
dbt show --limit 100 --inline "{{ profile_distinct_counts(ref('cmg_main_sample'), group_by='source_snapshot') }}"
```

`dbt compile --inline` prints the SQL without running it (paste it into R):

```bash
dbt compile --inline "{{ profile_distinct_counts(ref('cmg_main_sample')) }}"
```

Tip: `dbt show` truncates wide tables. Add `--output json` to see every column.

---

---

## 2. Macro reference and how to read results

Arguments, output columns and how to interpret them are documented in
[`macros/ad_hoc/docs/profiling_quickstart.md`](../macros/ad_hoc/docs/profiling_quickstart.md).

### `store_profile` in this pipeline

```bash
dbt run-operation store_profile --args '{"profile_schema": "main_cmg", "profile_table": "cmg_main_subject", "profile_group_by": ["source_snapshot"]}'
```

Read the result in R:

```r
# Latest stored column profile for cmg_main_subject
execute("select * from main_cmg.profile_cmg_main_subject order by profiled_at desc, column_name")
```
