BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a003_hier_item_rltd as
select
    A.parent_hier_item_id
    , A.child_hier_item_id
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v003_hier_item_rltd A
;
CALL dev_demo_ml.sp_deployment_objects('a003_hier_item_rltd','dev_demo_al');
END TRANSACTION;
