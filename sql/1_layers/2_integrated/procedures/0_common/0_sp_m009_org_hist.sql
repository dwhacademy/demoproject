BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m009_org_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm009_org';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m009_org
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v009_org  v_009
LEFT JOIN
    dev_demo_il.t009_org  t009
    ON md5_hash(t009.party_id) = md5_hash(v_009.party_id)
    AND md5_hash(t009.org_nm) = md5_hash(v_009.org_nm)
 
WHERE t009.party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'delete', V_AFF_CNT);
 
/********************************************
 * INSERT STATEMENT TO BE EXECUTED
********************************************/
INSERT INTO
    dev_demo_il.m009_org
SELECT
    t009.party_id,
    t009.org_nm,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t009_org  t009
LEFT JOIN
    dev_demo_il.v009_org  v_009
    ON md5_hash(t009.party_id) = md5_hash(v_009.party_id)
    AND md5_hash(t009.org_nm) = md5_hash(v_009.org_nm)
 
WHERE v_009.party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m009_org_hist','dev_demo_il');
END TRANSACTION;
 