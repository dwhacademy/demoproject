BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m017_party_contact_rltd()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m017_party_contact_rltd;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m017_party_contact_rltd', 'm017_party_contact_rltd','delete', V_AFF_CNT);
insert into
  dev_demo_il.m017_party_contact_rltd (
    party_id,
    contact_id,
    rel_cd
  )
select
  w_017.party_id,
  w_017.contact_id,
  w_017.rel_cd
from
  dev_demo_il.w_017_party_contact_rltd as w_017
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m017_party_contact_rltd', 'm017_party_contact_rltd','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m017_party_contact_rltd', 'dev_demo_il');
END TRANSACTION;


