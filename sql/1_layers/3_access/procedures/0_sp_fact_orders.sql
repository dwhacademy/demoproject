BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_fact_orders()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_al.fact_orders;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_fact_orders', 'fact_orders','delete', V_AFF_CNT);
insert into
  dev_demo_al.fact_orders (
    prod_id,
    order_id,
    customer_id,
    employee_id,
    store_id,
    order_start_dttm,
    order_due_dttm,
    order_complete_dttm,
    order_status,
    discount,
    order_amount
  )
select
  w_fact.prod_id,
  w_fact.order_id,
  w_fact.customer_id,
  w_fact.employee_id,
  w_fact.store_id,
  w_fact.order_start_dttm,
  w_fact.order_due_dttm,
  w_fact.order_complete_dttm,
  w_fact.order_status,
  w_fact.discount,
  w_fact.order_amount
from
  dev_demo_al.w_fact_orders as w_fact
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_fact_orders', 'fact_orders','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_fact_orders', 'dev_demo_al');
END TRANSACTION;


