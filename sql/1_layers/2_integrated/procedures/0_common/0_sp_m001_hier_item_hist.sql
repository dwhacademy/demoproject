BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m001_hier_item_hist
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
SET V_TARG_TBL_NM = 'm001_hier_item';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m001_hier_item
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v001_hier_item  v_001
LEFT JOIN
    dev_demo_il.t001_hier_item  t001
    ON md5(t001.hier_item_id) = md5(v_001.hier_item_id)
    AND md5(t001.hier_item_nm) = md5(v_001.hier_item_nm)
    AND md5(t001.lvl) = md5(v_001.lvl)
    AND md5(t001.hier_cd) = md5(v_001.hier_cd)
 
WHERE t001.hier_item_id IS NULL
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
    dev_demo_il.m001_hier_item
SELECT
    t001.hier_item_id,
    t001.hier_item_nm,
    t001.lvl,
    t001.hier_cd,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t001_hier_item  t001
LEFT JOIN
    dev_demo_il.v001_hier_item  v_001
    ON md5(t001.hier_item_id) = md5(v_001.hier_item_id)
    AND md5(t001.hier_item_nm) = md5(v_001.hier_item_nm)
    AND md5(t001.lvl) = md5(v_001.lvl)
    AND md5(t001.hier_cd) = md5(v_001.hier_cd)
 
WHERE v_001.hier_item_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m001_hier_item_hist','dev_demo_il');
END TRANSACTION;
 