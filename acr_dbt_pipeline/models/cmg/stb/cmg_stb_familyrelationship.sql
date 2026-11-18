-- family_member_id is the parent ("biological mother/father of" subject_id).
-- Resolve parent IDs only against subjects from the same source snapshot.
with parents as (
    select subject_id, source_snapshot_id, maternal_id as parent_id, 'KIN:027' as relation
    from {{ ref('cmg_int_subject') }}
    where maternal_id is not null
    union
    select subject_id, source_snapshot_id, paternal_id as parent_id, 'KIN:028' as relation
    from {{ ref('cmg_int_subject') }}
    where paternal_id is not null
)

select distinct
    {{ generate_md5_global_id(prefix='fr', descriptor=['p.parent_id', 'p.relation', 'p.subject_id', 'c.consent_group']) }}::text as "family_relationship_id",
    par.subject_gid::text as "family_member_id",
    p.relation::text as "relation",
    c.subject_gid::text as "subject_id",
    c.access_policy_gid::text as "access_policy_id",
    c.study_gid::text as "study_id"
from parents p
inner join {{ ref('cmg_int_subject') }} c
    on c.subject_id = p.subject_id
    and c.source_snapshot_id = p.source_snapshot_id
inner join {{ ref('cmg_int_subject') }} par
    on par.subject_id = p.parent_id
    and par.source_snapshot_id = p.source_snapshot_id
