BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m014_order_party_rltd_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm014_order_party_rltd';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m014_order_party_rltd
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v014_order_party_rltd  v_014
LEFT JOIN
    dev_demo_il.t014_order_party_rltd  t014
    ON md5_hash(t014.order_id) = md5_hash(v_014.order_id)
    AND md5_hash(t014.party_id) = md5_hash(v_014.party_id)
    AND md5_hash(t014.rel_cd) = md5_hash(v_014.rel_cd)
 
WHERE t014.order_id IS NULL
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
    dev_demo_il.m014_order_party_rltd
SELECT
    t014.order_id,
    t014.party_id,
    t014.rel_cd,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t014_order_party_rltd  t014
LEFT JOIN
    dev_demo_il.v014_order_party_rltd  v_014
    ON md5_hash(t014.order_id) = md5_hash(v_014.order_id)
    AND md5_hash(t014.party_id) = md5_hash(v_014.party_id)
    AND md5_hash(t014.rel_cd) = md5_hash(v_014.rel_cd)
 
WHERE v_014.order_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m014_order_party_rltd_hist','dev_demo_il');
END TRANSACTION;
 