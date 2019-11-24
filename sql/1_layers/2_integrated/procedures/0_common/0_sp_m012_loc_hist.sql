BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m012_loc_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm012_loc';
DECLARE V_KEY_TBL_NM VARCHAR(255) := 'k012_loc_key';
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
    dev_demo_il.k012_loc_key (
    loc_id
    , loc_src_pfx
    , loc_src_key
    , src_syst_id
  )
SELECT
    row_number() over(order by t012.loc_src_key) + k012.last_sk as loc_id
    , t012.loc_src_pfx
    , t012.loc_src_key
    , t012.src_syst_id
FROM
  dev_demo_il.t012_loc t012
CROSS JOIN
    (select coalesce(max(loc_id),1000000) as last_sk from dev_demo_il.k012_loc_key) k012
WHERE
    t012.loc_id is null
GROUP BY
    t012.loc_src_pfx,
    t012.loc_src_key,
    t012.src_syst_id,
    k012.last_sk
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_KEY_TBL_NM,'insert', V_AFF_CNT);
 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
UPDATE dev_demo_il.t012_loc t012
SET loc_id = k012.loc_id
FROM
    dev_demo_il.k012_loc_key k012
WHERE
    k012.loc_src_pfx = t012.loc_src_pfx AND
    k012.loc_src_key = t012.loc_src_key AND
    k012.src_syst_id = t012.src_syst_id AND
    t012.loc_id is null
;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m012_loc
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v012_loc  v_012
LEFT JOIN
    dev_demo_il.t012_loc  t012
    ON md5_hash(t012.loc_id) = md5_hash(v_012.loc_id)
    AND md5_hash(t012.loc_subtype) = md5_hash(v_012.loc_subtype)
 
WHERE t012.loc_id IS NULL
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
    dev_demo_il.m012_loc
SELECT
    t012.loc_id,
    t012.loc_subtype,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t012_loc  t012
LEFT JOIN
    dev_demo_il.v012_loc  v_012
    ON md5_hash(t012.loc_id) = md5_hash(v_012.loc_id)
    AND md5_hash(t012.loc_subtype) = md5_hash(v_012.loc_subtype)
 
WHERE v_012.loc_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m012_loc_hist','dev_demo_il');
END TRANSACTION;
 
