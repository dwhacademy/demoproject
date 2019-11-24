BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v013_order as
select
    order_id
    , order_cd
    , order_start_dttm
    , order_due_dttm
    , order_complete_dttm
    , status
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m013_order
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v013_order','dev_demo_il');
END TRANSACTION;
