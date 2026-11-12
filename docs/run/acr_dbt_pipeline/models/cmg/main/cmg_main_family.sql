
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_family__dbt_tmp"
  
    
    as (
      
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_family"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_family"
    );
    
  