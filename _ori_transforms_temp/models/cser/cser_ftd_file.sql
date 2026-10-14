{{ config(materialized='table', schema='cser_data') }}

select distinct
name::text as "filename",
curie::text as "format",
NULL::text as "data_type",
size_in_bytes::text as "size",
file_ref::text as "drs_uri",
    {{ generate_global_id(prefix='fd',descriptor=['name'], study_id='cser') }}::text as "file_metadata",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='fl',descriptor=['file_id'], study_id='cser') }}::text as "id"
from {{ ref('cser_stg_file_inventory') }} as fi
left join {{ ref('fl_format') }} as ff
on lower(replace(fi.full_extension,'.','')) = lower(ff.src_format)