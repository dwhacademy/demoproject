BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a013_order as
select
    A.order_id
    , A.order_cd
    , A.order_start_dttm
    , A.order_due_dttm
    , A.order_complete_dttm
    , A.status
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v013_order A
;
CALL dev_demo_ml.sp_deployment_objects('a013_order','dev_demo_al');
END TRANSACTION;
