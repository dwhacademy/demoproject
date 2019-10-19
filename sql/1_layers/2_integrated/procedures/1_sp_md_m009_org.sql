BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m009_org()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t009_org (
    party_id,
    org_nm
  )
select
  w_008.party_id,
  w_008.org_nm
from
  dev_demo_il.w_009_org as w_008
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m009_org_hist('sp_md_m009_org');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m009_org', 'dev_demo_il');
END TRANSACTION;


