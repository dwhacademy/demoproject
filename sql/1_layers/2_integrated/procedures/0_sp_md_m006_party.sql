BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m006_party()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m006_party;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m006_party', 'm006_party','delete', V_AFF_CNT);
insert into
  dev_demo_il.m006_party (
    party_id,
    party_subtype,
    party_cd,
    loc_id
  )
-- Individuals
select
  w_008.party_id,
  w_008.party_subtype,
  w_008.party_cd,
  w_008.loc_id
from
  dev_demo_il.w_008_indiv as w_008

union
-- Organizations
select
  w_009.party_id,
  w_009.party_subtype,
  w_009.party_cd,
  w_009.loc_id
from
  dev_demo_il.w_009_org as w_009
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m006_party', 'm006_party','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m006_party', 'dev_demo_il');
END TRANSACTION;


