
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."tt_concepts__dbt_tmp"
  
    
    as (
      select *
from read_csv('../../data/src_supplements/term_trawler/concepts.csv')
    );
    
  