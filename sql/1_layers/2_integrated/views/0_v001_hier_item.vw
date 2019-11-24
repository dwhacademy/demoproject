BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v001_hier_item as
select
    hier_item_id
    , hier_item_nm
    , lvl
    , hier_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m001_hier_item
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v001_hier_item','dev_demo_il');
END TRANSACTION;
