BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_dim_store(IN V_LOAD_ID INTEGER, INOUT STATUS VARCHAR(50), INOUT STEP_NM VARCHAR(50), INOUT V_SQLERRM VARCHAR(50), INOUT V_SQLSTATE VARCHAR(50))
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;

BEGIN
STATUS := 'Success';
STEP_NM := 'delete'; 
DELETE FROM dev_demo_al.t_dim_store WHERE load_id < COALESCE((SELECT MAX(load_id) FROM dev_demo_al.t_dim_store),0); 

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_store', CURRENT_TIMESTAMP, 'AL', 't_dim_store',STEP_NM, V_AFF_CNT);

STEP_NM := 'insert';
insert into
  dev_demo_al.t_dim_store (
    store_id,
    store_nm,
    phone,
    email,
    city,
    state,
    load_id
  )
select
  w_dim.store_id,
  w_dim.store_nm,
  w_dim.phone,
  w_dim.email,
  w_dim.city,
  w_dim.state,
  V_LOAD_ID
from
  dev_demo_al.w_dim_store as w_dim
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_store', CURRENT_TIMESTAMP, 'AL', 't_dim_store',STEP_NM, V_AFF_CNT);

EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_dim_store', 'dev_demo_al');
END TRANSACTION;


