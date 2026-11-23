select distinct
    person_gid::text as "person_person_id",
    subject_gid::text as "subject_id_subject_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_id is not null