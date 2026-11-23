
    
    

with all_values as (

    select
        participant_lifespan_stage as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_studymetadata_participant_lifespan_stage"
    group by participant_lifespan_stage

)

select *
from all_values
where value_field not in (
    'NCIT:C176390','NCIT:C199314','NCIT:C39298','NCIT:C89331','NCIT:C89344','NCIT:C89345','NCIT:C89346','NCIT:C89347','NCIT:C89885','NCIT:C89887','NCIT:C89888','NCIT:C89889','NCIT:C89890','NCIT:C90337','NCIT:C90338','NCIT:C90339','NCIT:C90340','NCIT:C99135'
)


