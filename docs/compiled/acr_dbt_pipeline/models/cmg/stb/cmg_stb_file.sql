select distinct
    file_gid::text as "file_id",
    name::text as "filename",
    full_extension::text as "file_extension",
    cast(null as text) as "data_category",
    cast(null as text) as "data_type",
    cast(null as text) as "format",
    size_in_bytes::bigint as "size",
    uri::text as "internal_uri",
    cast(null as text) as "release_uri",
    cast(null as text) as "drs_uri",
    cast(null as text) as "storage_class",
    cast(null as text) as "availability",
    access_policy_gid::text as "access_policy_id",
    study_gid::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_file_inventory"
where file_id is not null