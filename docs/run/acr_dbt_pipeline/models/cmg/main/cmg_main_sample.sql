
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_sample__dbt_tmp"
  
    
    as (
      
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_mc_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rared_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_sample"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_sample"
    );
    
  