BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m006_party()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t006_party (
    party_id,
    party_subtype,
    party_src_pfx,
    party_src_key,
    src_syst_id
  )
-- Individuals
select
  w_008.party_id,
  w_008.party_subtype,
  w_008.party_src_pfx,
  w_008.party_src_key,
  w_008.src_syst_id
from
  dev_demo_il.w_008_indiv as w_008

union
-- Organizations
select
  w_009.party_id,
  w_009.party_subtype,
  w_009.party_src_pfx,
  w_009.party_src_key,
  w_009.src_syst_id
from
  dev_demo_il.w_009_org as w_009
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m006_party_hist('sp_md_m006_party');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m006_party', 'dev_demo_il');
END TRANSACTION;


