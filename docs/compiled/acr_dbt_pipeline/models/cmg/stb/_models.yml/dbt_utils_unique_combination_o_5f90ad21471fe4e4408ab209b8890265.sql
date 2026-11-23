





with validation_errors as (

    select
        "SubjectAssertion_assertion_id", "external_id"
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_subjectassertion_external_id"
    group by "SubjectAssertion_assertion_id", "external_id"
    having count(*) > 1

)

select *
from validation_errors


