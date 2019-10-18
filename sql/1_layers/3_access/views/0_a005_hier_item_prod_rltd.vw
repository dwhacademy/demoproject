BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a005_hier_item_prod_rltd as
select
    A.hier_item_id
    , A.prod_id
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v005_hier_item_prod_rltd A
;
CALL dev_demo_ml.sp_deployment_objects('a005_hier_item_prod_rltd','dev_demo_al');
END TRANSACTION;
