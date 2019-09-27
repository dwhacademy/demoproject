BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_erp_m018_order_item()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m018_order_item;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_erp_m018_order_item', 'm018_order_item','delete', V_AFF_CNT);
insert into
  dev_demo_il.m018_order_item (
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
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_erp_m018_order_item', 'm018_order_item','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_erp_m018_order_item', 'dev_demo_il');
END TRANSACTION;


