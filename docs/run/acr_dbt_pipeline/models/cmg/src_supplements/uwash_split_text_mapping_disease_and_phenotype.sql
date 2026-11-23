
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."uwash_split_text_mapping_disease_and_phenotype__dbt_tmp"
  
    
    as (
      select *
from read_csv('../../data/src_supplements/uwash_split_text_mapping_disease_and_phenotype.csv')
    );
    
  