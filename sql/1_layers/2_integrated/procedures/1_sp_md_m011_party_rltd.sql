BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m011_party_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t011_party_rltd (
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
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m011_party_rltd_hist('sp_md_m011_party_rltd');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m011_party_rltd', 'dev_demo_il');
END TRANSACTION;


