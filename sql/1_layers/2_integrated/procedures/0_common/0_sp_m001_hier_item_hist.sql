BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m001_hier_item_hist
(
IN V_LOAD_ID INTEGER, 
INOUT STATUS VARCHAR(50), 
INOUT STEP_NM VARCHAR(50), 
INOUT V_SQLERRM VARCHAR(50), 
INOUT V_SQLSTATE VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;

BEGIN
 
/********************************************
 * SURROGATE KEY GENERATION
*********************************************/
STEP_NM := 'insert';
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
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_m001_hier_item_hist', CURRENT_TIMESTAMP, 'IL', 'k001_hier_item_key',STEP_NM, V_AFF_CNT);

 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
STEP_NM := 'update';
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
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_m001_hier_item_hist', CURRENT_TIMESTAMP, 'IL', 't001_hier_item',STEP_NM, V_AFF_CNT);

 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
STEP_NM := 'update';
UPDATE dev_demo_il.m001_hier_item
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v001_hier_item  v_001
LEFT JOIN
    dev_demo_il.t001_hier_item  t001
    ON md5_hash(t001.hier_item_id) = md5_hash(v_001.hier_item_id)
    AND md5_hash(t001.hier_item_nm) = md5_hash(v_001.hier_item_nm)
    AND md5_hash(t001.lvl) = md5_hash(v_001.lvl)
    AND md5_hash(t001.hier_cd) = md5_hash(v_001.hier_cd)
 
WHERE t001.hier_item_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_m001_hier_item_hist', CURRENT_TIMESTAMP, 'IL', 'm001_hier_item',STEP_NM, V_AFF_CNT);

 
/********************************************
 * INSERT STATEMENT TO BE EXECUTED
********************************************/
STEP_NM := 'insert';
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
    ON md5_hash(t001.hier_item_id) = md5_hash(v_001.hier_item_id)
    AND md5_hash(t001.hier_item_nm) = md5_hash(v_001.hier_item_nm)
    AND md5_hash(t001.lvl) = md5_hash(v_001.lvl)
    AND md5_hash(t001.hier_cd) = md5_hash(v_001.hier_cd)
 
WHERE v_001.hier_item_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_m001_hier_item_hist', CURRENT_TIMESTAMP, 'IL', 'm001_hier_item',STEP_NM, V_AFF_CNT);

STATUS := 'Success';
EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;

END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m001_hier_item_hist','dev_demo_il');
END TRANSACTION;
 