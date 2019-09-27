BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m011_party_rltd()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m011_party_rltd;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m011_party_rltd', 'm011_party_rltd','delete', V_AFF_CNT);
insert into
  dev_demo_il.m011_party_rltd (
    parent_party_id,
    child_party_id,
    rel_cd
  )
select
  w_011.parent_party_id,
  w_011.child_party_id,
  w_011.rel_cd
from
  dev_demo_il.w_011_party_rltd as w_011
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m011_party_rltd', 'm011_party_rltd','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m011_party_rltd', 'dev_demo_il');
END TRANSACTION;


