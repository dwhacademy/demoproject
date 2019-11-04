BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_dim_prod_hier(IN V_LOAD_ID INTEGER, INOUT STATUS VARCHAR(50), INOUT STEP_NM VARCHAR(50), INOUT V_SQLERRM VARCHAR(50), INOUT V_SQLSTATE VARCHAR(50))
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;

BEGIN
STATUS := 'Success';
STEP_NM := 'delete';
DELETE FROM dev_demo_al.t_dim_prod_hier WHERE load_id < COALESCE((SELECT MAX(load_id) FROM dev_demo_al.t_dim_prod_hier),0);  

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_prod_hier', CURRENT_TIMESTAMP, 'AL', 't_dim_prod_hier',STEP_NM, V_AFF_CNT);

STEP_NM := 'insert';
insert into
  dev_demo_al.t_dim_prod_hier (
    prod_id,
    prod_nm,
    price,
    model_year,
    lvl1_nm, 
    lvl2_nm,
    lvl3_nm,
    lvl4_nm,
    lvl5_nm,
    lvl6_nm,   
    lvl7_nm,
    lvl8_nm,
    lvl9_nm,
    load_id
  )
select
  w_dim.prod_id,
  w_dim.prod_nm,
  w_dim.price,
  w_dim.model_year,
  w_dim.lvl1_nm, 
  w_dim.lvl2_nm,
  w_dim.lvl3_nm,
  w_dim.lvl4_nm,
  w_dim.lvl5_nm,
  w_dim.lvl6_nm,   
  w_dim.lvl7_nm,
  w_dim.lvl8_nm,
  w_dim.lvl9_nm,
  V_LOAD_ID

from
  dev_demo_al.w_dim_prod_hier as w_dim
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_dim_prod_hier', CURRENT_TIMESTAMP, 'AL', 't_dim_prod_hier',STEP_NM, V_AFF_CNT);

EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_dim_prod_hier', 'dev_demo_al');
END TRANSACTION;