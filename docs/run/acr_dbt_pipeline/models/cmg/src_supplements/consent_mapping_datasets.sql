
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."consent_mapping_datasets__dbt_tmp"
  
    
    as (
      select *
from read_csv('../../data/consent/AnVIL CMG Consent, DUO and MeSH Mapping - Datasets 20261104.csv')
    );
    
  