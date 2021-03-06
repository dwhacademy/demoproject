BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_fact_orders(IN V_LOAD_ID INTEGER, INOUT STATUS VARCHAR(50), INOUT STEP_NM VARCHAR(50), INOUT V_SQLERRM VARCHAR(50), INOUT V_SQLSTATE VARCHAR(50))
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;

BEGIN
STATUS := 'Success';
STEP_NM := 'delete';
DELETE FROM dev_demo_al.t_fact_orders WHERE load_id < COALESCE((SELECT MAX(load_id) FROM dev_demo_al.t_fact_orders),0); 

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_fact_orders', CURRENT_TIMESTAMP, 'AL', 't_fact_orders',STEP_NM, V_AFF_CNT);

STEP_NM := 'insert';
insert into
  dev_demo_al.t_fact_orders (
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
    order_amount,
    load_id
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
  w_fact.order_amount,
  V_LOAD_ID
from
  dev_demo_al.w_fact_orders as w_fact
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_fact_orders', CURRENT_TIMESTAMP, 'AL', 't_fact_orders',STEP_NM, V_AFF_CNT);

EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_fact_orders', 'dev_demo_al');
END TRANSACTION;


