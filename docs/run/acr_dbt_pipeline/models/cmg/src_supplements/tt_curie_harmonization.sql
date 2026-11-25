
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization__dbt_tmp"
  
    
    as (
      select *
from read_csv('../../data/src_supplements/term_trawler/curie_harmonization.csv')
    );
    
  