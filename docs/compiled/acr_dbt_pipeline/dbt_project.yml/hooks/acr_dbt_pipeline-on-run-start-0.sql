create or replace macro acr_clean_text(v) as (
  case when lower(trim(v)) in ('', 'na', 'n/a', 'null', 'none') then null else trim(v) end
)