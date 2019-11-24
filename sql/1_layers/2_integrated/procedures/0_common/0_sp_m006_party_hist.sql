BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m006_party_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm006_party';
DECLARE V_KEY_TBL_NM VARCHAR(255) := 'k006_party_key';
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
    dev_demo_il.k006_party_key (
    party_id
    , party_src_pfx
    , party_src_key
    , src_syst_id
  )
SELECT
    row_number() over(order by t006.party_src_key) + k006.last_sk as party_id
    , t006.party_src_pfx
    , t006.party_src_key
    , t006.src_syst_id
FROM
  dev_demo_il.t006_party t006
CROSS JOIN
    (select coalesce(max(party_id),1000000) as last_sk from dev_demo_il.k006_party_key) k006
WHERE
    t006.party_id is null
GROUP BY
    t006.party_src_pfx,
    t006.party_src_key,
    t006.src_syst_id,
    k006.last_sk
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_KEY_TBL_NM,'insert', V_AFF_CNT);
 
/********************************************
 * MERGING SURROGATE KEYS BACK TO TEMP TABLE
********************************************/
UPDATE dev_demo_il.t006_party t006
SET party_id = k006.party_id
FROM
    dev_demo_il.k006_party_key k006
WHERE
    k006.party_src_pfx = t006.party_src_pfx AND
    k006.party_src_key = t006.party_src_key AND
    k006.src_syst_id = t006.src_syst_id AND
    t006.party_id is null
;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m006_party
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v006_party  v_006
LEFT JOIN
    dev_demo_il.t006_party  t006
    ON md5_hash(t006.party_id) = md5_hash(v_006.party_id)
    AND md5_hash(t006.party_subtype) = md5_hash(v_006.party_subtype)
 
WHERE t006.party_id IS NULL
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
    dev_demo_il.m006_party
SELECT
    t006.party_id,
    t006.party_subtype,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t006_party  t006
LEFT JOIN
    dev_demo_il.v006_party  v_006
    ON md5_hash(t006.party_id) = md5_hash(v_006.party_id)
    AND md5_hash(t006.party_subtype) = md5_hash(v_006.party_subtype)
 
WHERE v_006.party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m006_party_hist','dev_demo_il');
END TRANSACTION;
 
