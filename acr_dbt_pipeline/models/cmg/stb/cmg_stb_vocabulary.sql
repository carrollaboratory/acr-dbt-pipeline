{{ config(materialized='table') }}

select *
from {{ ref('tt_vocabulary') }}