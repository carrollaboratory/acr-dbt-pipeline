
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_anvil_dataset__dbt_tmp"
  
    
    as (
      
select * exclude ("consent_group") from (
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_anvil_dataset"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_anvil_dataset"
)
    );
    
  