select *
from {{ ref("mapdragon_annotations_talon") }} md

left join

select *
from {{ ref('uwash_split_text_mapping_disease_and_phenotype') }}
on source_text = split_text
where md.source_system = 'https://anvilproject.org//Yale CMG (Addendum)'