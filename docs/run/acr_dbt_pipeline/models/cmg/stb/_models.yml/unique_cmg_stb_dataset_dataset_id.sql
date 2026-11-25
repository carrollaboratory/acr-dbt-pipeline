
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    dataset_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset"
where dataset_id is not null
group by dataset_id
having count(*) > 1



  
  
      
    ) dbt_internal_test