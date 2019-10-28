BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_dim_customer(IN V_LOAD_ID INTEGER, INOUT STATUS VARCHAR(50), INOUT STEP_NM VARCHAR(50), INOUT V_SQLERRM VARCHAR(50), INOUT V_SQLSTATE VARCHAR(50))
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;

BEGIN
STATUS := 'Success';
STEP_NM := 'delete';
DELETE FROM dev_demo_al.t_dim_customer WHERE load_id < COALESCE((SELECT MAX(load_id) FROM dev_demo_al.t_dim_customer),0);

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_customer', CURRENT_TIMESTAMP, 'AL', 't_dim_customer',STEP_NM, V_AFF_CNT);

STEP_NM := 'insert';
insert into
  dev_demo_al.t_dim_customer (
    customer_id,
    customer_nm,
    phone,
    email,
    city,
    state,
    load_id
  )
select
  w_dim.customer_id,
  w_dim.customer_nm,
  w_dim.phone,
  w_dim.email,
  w_dim.city,
  w_dim.state,
  V_LOAD_ID
from
  dev_demo_al.w_dim_customer as w_dim
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_customer', CURRENT_TIMESTAMP, 'AL', 't_dim_customer',STEP_NM, V_AFF_CNT);

EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_dim_customer', 'dev_demo_al');
END TRANSACTION;


