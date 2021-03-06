BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m013_order_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm013_order';
DECLARE V_KEY_TBL_NM VARCHAR(255) := 'k013_order_key';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * SURROGATE KEY GENERATION
*********************************************/
insert into
    dev_demo_il.k013_order_key (
    order_id
    , order_src_pfx
    , order_src_key
    , src_syst_id
  )
SELECT
    row_number() over(order by t013.order_src_key) + k013.last_sk as order_id
    , t013.order_src_pfx
    , t013.order_src_key
    , t013.src_syst_id
FROM
  dev_demo_il.t013_order t013
CROSS JOIN
    (select coalesce(max(order_id),1000000) as last_sk from dev_demo_il.k013_order_key) k013
WHERE
    t013.order_id is null
GROUP BY
    t013.order_src_pfx,
    t013.order_src_key,
    t013.src_syst_id,
    k013.last_sk
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_KEY_TBL_NM,'insert', V_AFF_CNT);
 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
UPDATE dev_demo_il.t013_order t013
SET order_id = k013.order_id
FROM
    dev_demo_il.k013_order_key k013
WHERE
    k013.order_src_pfx = t013.order_src_pfx AND
    k013.order_src_key = t013.order_src_key AND
    k013.src_syst_id = t013.src_syst_id AND
    t013.order_id is null
;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m013_order
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v013_order  v_013
LEFT JOIN
    dev_demo_il.t013_order  t013
    ON md5_hash(t013.order_id) = md5_hash(v_013.order_id)
    AND md5_hash(t013.order_cd) = md5_hash(v_013.order_cd)
    AND md5_hash(t013.order_start_dttm) = md5_hash(v_013.order_start_dttm)
    AND md5_hash(t013.order_due_dttm) = md5_hash(v_013.order_due_dttm)
    AND md5_hash(t013.order_complete_dttm) = md5_hash(v_013.order_complete_dttm)
    AND md5_hash(t013.status) = md5_hash(v_013.status)
 
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
    ON md5_hash(t013.order_id) = md5_hash(v_013.order_id)
    AND md5_hash(t013.order_cd) = md5_hash(v_013.order_cd)
    AND md5_hash(t013.order_start_dttm) = md5_hash(v_013.order_start_dttm)
    AND md5_hash(t013.order_due_dttm) = md5_hash(v_013.order_due_dttm)
    AND md5_hash(t013.order_complete_dttm) = md5_hash(v_013.order_complete_dttm)
    AND md5_hash(t013.status) = md5_hash(v_013.status)
 
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
 
