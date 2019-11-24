BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v004_prod as
select
    prod_id
    , prod_cd
    , prod_nm
    , model_year
    , price
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m004_prod
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v004_prod','dev_demo_il');
END TRANSACTION;
