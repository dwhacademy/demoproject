BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m016_contact_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm016_contact';
DECLARE V_KEY_TBL_NM VARCHAR(255) := 'k016_contact_key';
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
    dev_demo_il.k016_contact_key (
    contact_id
    , contact_src_pfx
    , contact_src_key
    , src_syst_id
  )
SELECT
    row_number() over(order by t016.contact_src_key) + k016.last_sk as contact_id
    , t016.contact_src_pfx
    , t016.contact_src_key
    , t016.src_syst_id
FROM
  dev_demo_il.t016_contact t016
CROSS JOIN
    (select coalesce(max(contact_id),1000000) as last_sk from dev_demo_il.k016_contact_key) k016
WHERE
    t016.contact_id is null
GROUP BY
    t016.contact_src_pfx,
    t016.contact_src_key,
    t016.src_syst_id,
    k016.last_sk
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_KEY_TBL_NM,'insert', V_AFF_CNT);
 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
UPDATE dev_demo_il.t016_contact t016
SET contact_id = k016.contact_id
FROM
    dev_demo_il.k016_contact_key k016
WHERE
    k016.contact_src_pfx = t016.contact_src_pfx AND
    k016.contact_src_key = t016.contact_src_key AND
    k016.src_syst_id = t016.src_syst_id AND
    t016.contact_id is null
;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m016_contact
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v016_contact  v_016
LEFT JOIN
    dev_demo_il.t016_contact  t016
    ON md5_hash(t016.contact_id) = md5_hash(v_016.contact_id)
    AND md5_hash(t016.contact_type) = md5_hash(v_016.contact_type)
    AND md5_hash(t016.contact_txt) = md5_hash(v_016.contact_txt)
 
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
    ON md5_hash(t016.contact_id) = md5_hash(v_016.contact_id)
    AND md5_hash(t016.contact_type) = md5_hash(v_016.contact_type)
    AND md5_hash(t016.contact_txt) = md5_hash(v_016.contact_txt)
 
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
 
