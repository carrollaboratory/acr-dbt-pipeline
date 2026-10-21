{{ config(materialized='table', schema='cser_data') }}

{%- set fi_metadata_columns = ['crc32c','md5_hash'] -%}
{%- set seq_metadata_columns = ['alignment_method','analyte_type','functional_equivalence_standard','library_prep_kit_method','reference_genome_build'] -%}
with
unpivot_df as (
    {%- for col in fi_metadata_columns -%}
        select
            distinct 
            file_id as "file_id",
            '{{ col }}' as "display",
            cast({{ col }} as varchar) as "value_display",
            CONCAT(ftd_index,'_fi') as "ftd_index"
        from {{ ref('cser_stg_file_inventory') }}
        where {{ col }} IS NOT NULL
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
        union all
   
    {% for col in seq_metadata_columns %}
        select
            distinct 
            sequencing_id as "file_id",
            '{{ col }}' as "display",
            cast({{ col }} as varchar) as "value_display",
            CONCAT(ftd_index,'_seq') as "ftd_index"
        from {{ ref('cser_stg_sequencing') }}
        where {{ col }} IS NOT NULL
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
)
select distinct
NULL::text as "code",
display::text as "display",
NULL::text as "value_code",
value_display::text as "value_display",
    {{ generate_global_id(prefix='fd',descriptor=['file_id'], study_id='cser') }}::text as "id"
from unpivot_df