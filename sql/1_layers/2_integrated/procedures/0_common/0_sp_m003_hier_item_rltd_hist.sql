BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m003_hier_item_rltd_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm003_hier_item_rltd';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m003_hier_item_rltd
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v003_hier_item_rltd  v_003
LEFT JOIN
    dev_demo_il.t003_hier_item_rltd  t003
    ON md5(t003.parent_hier_item_id) = md5(v_003.parent_hier_item_id)
    AND md5(t003.child_hier_item_id) = md5(v_003.child_hier_item_id)
 
WHERE t003.parent_hier_item_id IS NULL
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
    dev_demo_il.m003_hier_item_rltd
SELECT
    t003.parent_hier_item_id,
    t003.child_hier_item_id,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t003_hier_item_rltd  t003
LEFT JOIN
    dev_demo_il.v003_hier_item_rltd  v_003
    ON md5(t003.parent_hier_item_id) = md5(v_003.parent_hier_item_id)
    AND md5(t003.child_hier_item_id) = md5(v_003.child_hier_item_id)
 
WHERE v_003.parent_hier_item_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m003_hier_item_rltd_hist','dev_demo_il');
END TRANSACTION;
 