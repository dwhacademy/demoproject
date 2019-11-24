BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m017_party_contact_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t017_party_contact_rltd;
insert into
  dev_demo_il.t017_party_contact_rltd (
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
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m017_party_contact_rltd_hist('sp_md_m017_party_contact_rltd');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m017_party_contact_rltd', 'dev_demo_il');
END TRANSACTION;


