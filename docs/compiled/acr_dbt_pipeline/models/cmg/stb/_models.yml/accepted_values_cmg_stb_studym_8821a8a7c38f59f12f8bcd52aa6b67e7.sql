
    
    

with all_values as (

    select
        clinical_data_source_type as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_clinical_data_source_type"
    group by clinical_data_source_type

)

select *
from all_values
where value_field not in (
    'CAMO:0000014','CAMO:0000010','CAMO:0000011','CAMO:0000012','CAMO:0000013'
)


