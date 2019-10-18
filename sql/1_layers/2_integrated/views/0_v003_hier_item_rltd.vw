BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v003_hier_item_rltd as
select
    parent_hier_item_id
    , child_hier_item_id
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m003_hier_item_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v003_hier_item_rltd','dev_demo_il');
END TRANSACTION;
