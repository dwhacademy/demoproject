BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v018_order_item as
select
    order_id
    , prod_id
    , quantity
    , price
    , discount
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m018_order_item
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v018_order_item','dev_demo_il');
END TRANSACTION;
