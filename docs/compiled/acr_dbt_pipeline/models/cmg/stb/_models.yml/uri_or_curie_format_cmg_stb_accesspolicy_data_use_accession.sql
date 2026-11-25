

select data_use_accession as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
where data_use_accession is not null
  and not 
    regexp_matches(cast(data_use_accession as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(data_use_accession as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


