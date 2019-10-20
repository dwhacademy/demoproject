BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m007_party_loc_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t007_party_loc_rltd;
insert into
  dev_demo_il.t007_party_loc_rltd (
    party_id,
    loc_id,
    rel_cd
  )
select
  w_007.party_id,
  w_007.loc_id,
  w_007.rel_cd
from
  dev_demo_il.w_007_party_loc_rltd as w_007
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m007_party_loc_rltd_hist('sp_md_m007_party_loc_rltd');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m007_party_loc_rltd', 'dev_demo_il');
END TRANSACTION;


