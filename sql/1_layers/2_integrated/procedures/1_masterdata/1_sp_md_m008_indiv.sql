BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m008_indiv()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t008_indiv;
insert into
  dev_demo_il.t008_indiv (
    party_id,
    first_nm,
    last_nm,
    active_flag
  )
select
  w_008.party_id,
  w_008.first_nm,
  w_008.last_nm,
  w_008.active_flag
from
  dev_demo_il.w_008_indiv as w_008
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m008_indiv_hist('sp_md_m008_indiv');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m008_indiv', 'dev_demo_il');
END TRANSACTION;


