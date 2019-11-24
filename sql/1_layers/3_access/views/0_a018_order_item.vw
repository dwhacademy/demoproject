BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a018_order_item as
select
    A.order_id
    , A.prod_id
    , A.quantity
    , A.price
    , A.discount
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v018_order_item A
;
CALL dev_demo_ml.sp_deployment_objects('a018_order_item','dev_demo_al');
END TRANSACTION;
