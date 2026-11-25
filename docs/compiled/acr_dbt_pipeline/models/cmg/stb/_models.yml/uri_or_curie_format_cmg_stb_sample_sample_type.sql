

select sample_type as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample"
where sample_type is not null
  and not 
    regexp_matches(cast(sample_type as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(sample_type as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


