BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m011_party_rltd_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255);
DECLARE V_SCHEMA_NM VARCHAR(255);
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SET V_TARG_TBL_NM = 'm011_party_rltd';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m011_party_rltd
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v011_party_rltd  v_011
LEFT JOIN
    dev_demo_il.t011_party_rltd  t011
    ON md5(t011.parent_party_id) = md5(v_011.parent_party_id)
    AND md5(t011.child_party_id) = md5(v_011.child_party_id)
    AND md5(t011.rel_cd) = md5(v_011.rel_cd)
 
WHERE t011.parent_party_id IS NULL
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
    dev_demo_il.m011_party_rltd
SELECT
    t011.parent_party_id,
    t011.child_party_id,
    t011.rel_cd,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t011_party_rltd  t011
LEFT JOIN
    dev_demo_il.v011_party_rltd  v_011
    ON md5(t011.parent_party_id) = md5(v_011.parent_party_id)
    AND md5(t011.child_party_id) = md5(v_011.child_party_id)
    AND md5(t011.rel_cd) = md5(v_011.rel_cd)
 
WHERE v_011.parent_party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m011_party_rltd_hist','dev_demo_il');
END TRANSACTION;
 