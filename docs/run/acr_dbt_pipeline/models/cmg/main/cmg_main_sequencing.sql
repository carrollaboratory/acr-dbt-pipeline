
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_main_sequencing__dbt_tmp"
  
    
    as (
      
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_gru_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_gso_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_hmb_irb_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_rd_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_bpeakd_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_yale_src_ds_thal_irb_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_gru_irb_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_hmb_irb_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_ep_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_hfa_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bdis_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_nbia_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_chdef_sequencing"
union all by name
select * from "acr_dbt_pipeline"."main_cmg"."cmg_uwash_src_ds_bav_irb_pub_rd_sequencing"
    );
    
  