

select organism_type as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_subject"
where organism_type is not null
  and not 
    regexp_matches(cast(organism_type as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(organism_type as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


