BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m016_contact_hist
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
SET V_TARG_TBL_NM = 'm016_contact';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m016_contact
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v016_contact  v_016
LEFT JOIN
    dev_demo_il.t016_contact  t016
    ON md5(t016.contact_id) = md5(v_016.contact_id)
    AND md5(t016.contact_type) = md5(v_016.contact_type)
    AND md5(t016.contact_txt) = md5(v_016.contact_txt)
 
WHERE t016.contact_id IS NULL
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
    dev_demo_il.m016_contact
SELECT
    t016.contact_id,
    t016.contact_type,
    t016.contact_txt,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t016_contact  t016
LEFT JOIN
    dev_demo_il.v016_contact  v_016
    ON md5(t016.contact_id) = md5(v_016.contact_id)
    AND md5(t016.contact_type) = md5(v_016.contact_type)
    AND md5(t016.contact_txt) = md5(v_016.contact_txt)
 
WHERE v_016.contact_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m016_contact_hist','dev_demo_il');
END TRANSACTION;
 