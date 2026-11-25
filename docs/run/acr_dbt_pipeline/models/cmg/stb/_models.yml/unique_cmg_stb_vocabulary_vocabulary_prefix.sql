
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    vocabulary_prefix as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_vocabulary"
where vocabulary_prefix is not null
group by vocabulary_prefix
having count(*) > 1



  
  
      
    ) dbt_internal_test