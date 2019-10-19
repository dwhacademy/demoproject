BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m004_prod_hist
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
SET V_TARG_TBL_NM = 'm004_prod';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m004_prod
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v004_prod  v_004
LEFT JOIN
    dev_demo_il.t004_prod  t004
    ON md5(t004.prod_id) = md5(v_004.prod_id)
    AND md5(t004.prod_cd) = md5(v_004.prod_cd)
    AND md5(t004.prod_nm) = md5(v_004.prod_nm)
    AND md5(t004.model_year) = md5(v_004.model_year)
    AND md5(t004.price) = md5(v_004.price)
 
WHERE t004.prod_id IS NULL
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
    dev_demo_il.m004_prod
SELECT
    t004.prod_id,
    t004.prod_cd,
    t004.prod_nm,
    t004.model_year,
    t004.price,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t004_prod  t004
LEFT JOIN
    dev_demo_il.v004_prod  v_004
    ON md5(t004.prod_id) = md5(v_004.prod_id)
    AND md5(t004.prod_cd) = md5(v_004.prod_cd)
    AND md5(t004.prod_nm) = md5(v_004.prod_nm)
    AND md5(t004.model_year) = md5(v_004.model_year)
    AND md5(t004.price) = md5(v_004.price)
 
WHERE v_004.prod_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m004_prod_hist','dev_demo_il');
END TRANSACTION;
 