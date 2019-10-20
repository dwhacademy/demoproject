BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m001_hier_item_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm001_hier_item';
DECLARE V_KEY_TBL_NM VARCHAR(255) := 'k001_hier_item_key';
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
    dev_demo_il.k001_hier_item_key (
    hier_item_id
    , hier_item_src_pfx
    , hier_item_src_key
    , src_syst_id
  )
SELECT
    row_number() over(order by t001.hier_item_src_key) + k001.last_sk as hier_item_id
    , t001.hier_item_src_pfx
    , t001.hier_item_src_key
    , t001.src_syst_id
FROM
  dev_demo_il.t001_hier_item t001
CROSS JOIN
    (select coalesce(max(hier_item_id),1000000) as last_sk from dev_demo_il.k001_hier_item_key) k001
WHERE
    t001.hier_item_id is null
GROUP BY
    t001.hier_item_src_pfx,
    t001.hier_item_src_key,
    t001.src_syst_id,
    k001.last_sk
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_KEY_TBL_NM,'insert', V_AFF_CNT);
 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
UPDATE dev_demo_il.t001_hier_item t001
SET hier_item_id = k001.hier_item_id
FROM
    dev_demo_il.k001_hier_item_key k001
WHERE
    k001.hier_item_src_pfx = t001.hier_item_src_pfx AND
    k001.hier_item_src_key = t001.hier_item_src_key AND
    k001.src_syst_id = t001.src_syst_id AND
    t001.hier_item_id is null
;
 
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
 