
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon__dbt_tmp"
  
    
    as (
      select *
from read_csv('../../data/src_supplements/mapdragon_annotations_talon.csv')
    );
    
  