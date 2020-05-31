BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m002_hier
(
IN V_LOAD_ID INTEGER, 
INOUT STATUS VARCHAR(50), 
INOUT STEP_NM VARCHAR(50), 
INOUT V_SQLERRM VARCHAR(50), 
INOUT V_SQLSTATE VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;
BEGIN

--DELETE TABLE
STEP_NM := 'delete';
DELETE FROM dev_demo_il.m002_hier;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_md_m002_hier', CURRENT_TIMESTAMP, 'IL', 'm002_hier',STEP_NM, V_AFF_CNT);

--INSERT SCRIPTS
STEP_NM := 'insert';
INSERT INTO dev_demo_il.m002_hier(hier_cd, hier_nm) VALUES(1, 'Product_Group')
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_md_m002_hier', CURRENT_TIMESTAMP, 'IL', 'm002_hier',STEP_NM, V_AFF_CNT);

STATUS := 'Success';
EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m002_hier', 'dev_demo_il');
END TRANSACTION;

