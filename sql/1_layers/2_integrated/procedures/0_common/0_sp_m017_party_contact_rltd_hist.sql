BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE  dev_demo_il.sp_m017_party_contact_rltd_hist
(
in PROC_NM VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
DECLARE V_TARG_TBL_NM VARCHAR(255) := 'm017_party_contact_rltd';
DECLARE V_SCHEMA_NM VARCHAR(255) := 'dev_demo_il';
BEGIN
/********************************************
 * SET PROCEDURE CONSTANTS
********************************************/
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load;
 
/********************************************
 * UPDATE STATEMENT TO BE EXECUTED
********************************************/
UPDATE dev_demo_il.m017_party_contact_rltd
SET dw_end_dttm = CURRENT_TIMESTAMP
FROM 
    dev_demo_il.v017_party_contact_rltd  v_017
LEFT JOIN
    dev_demo_il.t017_party_contact_rltd  t017
    ON md5_hash(t017.party_id) = md5_hash(v_017.party_id)
    AND md5_hash(t017.relation_nm) = md5_hash(v_017.relation_nm)
    AND md5_hash(t017.contact_id) = md5_hash(v_017.contact_id)
    AND md5_hash(t017.phone) = md5_hash(v_017.phone)
    AND md5_hash(t017.rel_cd) = md5_hash(v_017.rel_cd)
 
WHERE t017.party_id IS NULL
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
    dev_demo_il.m017_party_contact_rltd
SELECT
    t017.party_id,
    t017.relation_nm,
    t017.contact_id,
    t017.phone,
    t017.rel_cd,
    CURRENT_TIMESTAMP AS dw_start_dttm, 
    TIMESTAMP '2100-01-01 00:00:00' AS dw_end_dttm 
FROM
    dev_demo_il.t017_party_contact_rltd  t017
LEFT JOIN
    dev_demo_il.v017_party_contact_rltd  v_017
    ON md5_hash(t017.party_id) = md5_hash(v_017.party_id)
    AND md5_hash(t017.relation_nm) = md5_hash(v_017.relation_nm)
    AND md5_hash(t017.contact_id) = md5_hash(v_017.contact_id)
    AND md5_hash(t017.phone) = md5_hash(v_017.phone)
    AND md5_hash(t017.rel_cd) = md5_hash(v_017.rel_cd)
 
WHERE v_017.party_id IS NULL
;
 
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, V_SCHEMA_NM, PROC_NM, V_TARG_TBL_NM,'insert', V_AFF_CNT);
 
END
$$;
 
CALL dev_demo_ml.sp_deployment_objects('sp_m017_party_contact_rltd_hist','dev_demo_il');
END TRANSACTION;
 