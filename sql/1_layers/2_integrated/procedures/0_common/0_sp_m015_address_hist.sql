BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m015_address_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm015_address';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m015_address
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v015_address  v_015
LEFT JOIN
    dev_demo_il.t015_address  t015
    ON md5_hash(t015.loc_id) = md5_hash(v_015.loc_id)
    AND md5_hash(t015.street) = md5_hash(v_015.street)
    AND md5_hash(t015.city) = md5_hash(v_015.city)
    AND md5_hash(t015.state) = md5_hash(v_015.state)
    AND md5_hash(t015.zip_cd) = md5_hash(v_015.zip_cd)
 
WHERE t015.loc_id IS NULL
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
    dev_demo_il.m015_address
SELECT
    t015.loc_id,
    t015.street,
    t015.city,
    t015.state,
    t015.zip_cd,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t015_address  t015
LEFT JOIN
    dev_demo_il.v015_address  v_015
    ON md5_hash(t015.loc_id) = md5_hash(v_015.loc_id)
    AND md5_hash(t015.street) = md5_hash(v_015.street)
    AND md5_hash(t015.city) = md5_hash(v_015.city)
    AND md5_hash(t015.state) = md5_hash(v_015.state)
    AND md5_hash(t015.zip_cd) = md5_hash(v_015.zip_cd)
 
WHERE v_015.loc_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m015_address_hist','dev_demo_il');
END TRANSACTION;
 