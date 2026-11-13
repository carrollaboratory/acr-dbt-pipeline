select 

study_name::text as md_study_name,
study_id::text as md_study_id,
dd_name::text as md_dd_name,
dd_id::text as md_dd_id,
version::text as harmony_export_date,
table_id::text as md_table_id,
"local code"::text as code,
"text"::text as code_text,
table_name::text as md_table_name,
parent_varname::text as code_parent_code,
"local code system"::text as code_system,
mapping_relationship::text as code_relationship_to_mapped_code,
code::text as mapped_code,
display::text as mapped_code_display,
"code system"::text as mapped_code_ontology_system,
comment::text as comment
from read_csv('../../data/CMG Data Model mappings.csv')