BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m018_order_item_hist
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
SET V_TARG_TBL_NM = 'm018_order_item';
SET V_SCHEMA_NM = 'dev_demo_il';
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m018_order_item
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v018_order_item  v_018
LEFT JOIN
    dev_demo_il.t018_order_item  t018
    ON md5(t018.order_id) = md5(v_018.order_id)
    AND md5(t018.prod_id) = md5(v_018.prod_id)
    AND md5(t018.quantity) = md5(v_018.quantity)
    AND md5(t018.price) = md5(v_018.price)
    AND md5(t018.discount) = md5(v_018.discount)
 
WHERE t018.order_id IS NULL
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
    dev_demo_il.m018_order_item
SELECT
    t018.order_id,
    t018.prod_id,
    t018.quantity,
    t018.price,
    t018.discount,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t018_order_item  t018
LEFT JOIN
    dev_demo_il.v018_order_item  v_018
    ON md5(t018.order_id) = md5(v_018.order_id)
    AND md5(t018.prod_id) = md5(v_018.prod_id)
    AND md5(t018.quantity) = md5(v_018.quantity)
    AND md5(t018.price) = md5(v_018.price)
    AND md5(t018.discount) = md5(v_018.discount)
 
WHERE v_018.order_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m018_order_item_hist','dev_demo_il');
END TRANSACTION;
 