

select website as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
where website is not null
  and not 
    regexp_matches(cast(website as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')


