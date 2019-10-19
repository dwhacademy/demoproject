BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m008_indiv_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm008_indiv';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m008_indiv
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v008_indiv  v_008
LEFT JOIN
    dev_demo_il.t008_indiv  t008
    ON md5(t008.party_id) = md5(v_008.party_id)
    AND md5(t008.first_nm) = md5(v_008.first_nm)
    AND md5(t008.last_nm) = md5(v_008.last_nm)
    AND md5(t008.active_flag) = md5(v_008.active_flag)
 
WHERE t008.party_id IS NULL
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
    dev_demo_il.m008_indiv
SELECT
    t008.party_id,
    t008.first_nm,
    t008.last_nm,
    t008.active_flag,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t008_indiv  t008
LEFT JOIN
    dev_demo_il.v008_indiv  v_008
    ON md5(t008.party_id) = md5(v_008.party_id)
    AND md5(t008.first_nm) = md5(v_008.first_nm)
    AND md5(t008.last_nm) = md5(v_008.last_nm)
    AND md5(t008.active_flag) = md5(v_008.active_flag)
 
WHERE v_008.party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m008_indiv_hist','dev_demo_il');
END TRANSACTION;
 