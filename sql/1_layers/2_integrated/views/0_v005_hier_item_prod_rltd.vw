BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v005_hier_item_prod_rltd as
select
    hier_item_id
    , prod_id
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m005_hier_item_prod_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v005_hier_item_prod_rltd','dev_demo_il');
END TRANSACTION;
