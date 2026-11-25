
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        relation as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship"
    group by relation

)

select *
from all_values
where value_field not in (
    'KIN:001','KIN:053','KIN:022','KIN:027','KIN:039','KIN:038','KIN:051','KIN:010','KIN:055','KIN:008','KIN:052','KIN:028','KIN:013','KIN:003','KIN:059','KIN:005','KIN:023','KIN:036','KIN:025','KIN:058','KIN:004','KIN:024','KIN:009','KIN:061','KIN:060','KIN:029','KIN:047','KIN:021','KIN:057','KIN:030','KIN:046','KIN:012','KIN:014','KIN:015','KIN:050','KIN:056','KIN:032','KIN:020','KIN:007','KIN:002','KIN:018','KIN:011','KIN:006','KIN:017','KIN:016','KIN:026','KIN:019','KIN:054','snomedct:261665006'
)



  
  
      
    ) dbt_internal_test