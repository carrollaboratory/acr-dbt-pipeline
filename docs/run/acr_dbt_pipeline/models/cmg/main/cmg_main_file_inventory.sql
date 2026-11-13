
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_file_inventory__dbt_tmp"
  
    
    as (
      
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_file_inventory"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_file_inventory"
    );
    
  