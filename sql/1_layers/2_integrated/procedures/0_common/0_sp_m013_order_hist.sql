BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m013_order_hist
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
SET V_TARG_TBL_NM = 'm013_order';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m013_order
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v013_order  v_013
LEFT JOIN
    dev_demo_il.t013_order  t013
    ON md5(t013.order_id) = md5(v_013.order_id)
    AND md5(t013.order_cd) = md5(v_013.order_cd)
    AND md5(t013.order_start_dttm) = md5(v_013.order_start_dttm)
    AND md5(t013.order_due_dttm) = md5(v_013.order_due_dttm)
    AND md5(t013.order_complete_dttm) = md5(v_013.order_complete_dttm)
    AND md5(t013.status) = md5(v_013.status)
 
WHERE t013.order_id IS NULL
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
    dev_demo_il.m013_order
SELECT
    t013.order_id,
    t013.order_cd,
    t013.order_start_dttm,
    t013.order_due_dttm,
    t013.order_complete_dttm,
    t013.status,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t013_order  t013
LEFT JOIN
    dev_demo_il.v013_order  v_013
    ON md5(t013.order_id) = md5(v_013.order_id)
    AND md5(t013.order_cd) = md5(v_013.order_cd)
    AND md5(t013.order_start_dttm) = md5(v_013.order_start_dttm)
    AND md5(t013.order_due_dttm) = md5(v_013.order_due_dttm)
    AND md5(t013.order_complete_dttm) = md5(v_013.order_complete_dttm)
    AND md5(t013.status) = md5(v_013.status)
 
WHERE v_013.order_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m013_order_hist','dev_demo_il');
END TRANSACTION;
 