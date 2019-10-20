BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_erp_m018_order_item()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t018_order_item;
insert into
  dev_demo_il.t018_order_item (
    order_id,
    prod_id,
    quantity,
    price,
    discount
  )
select
  w_018.order_id,
  w_018.prod_id,
  w_018.quantity,
  w_018.price,
  w_018.discount
from
  dev_demo_il.w_018_order_item as w_018
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m018_order_item_hist('sp_erp_m018_order_item');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_erp_m018_order_item', 'dev_demo_il');
END TRANSACTION;


