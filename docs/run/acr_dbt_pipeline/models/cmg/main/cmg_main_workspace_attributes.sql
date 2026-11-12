
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_workspace_attributes__dbt_tmp"
  
    
    as (
      
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_workspace_attributes"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_workspace_attributes"
    );
    
  