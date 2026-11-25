
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations__dbt_tmp"
  
    
    as (
      select
    mapping.*,
    metadata.* exclude (source_concept)
from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon" as mapping
left join "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata" as metadata
    on metadata.source_concept = mapping.mapped_code
    );
    
  