BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m012_loc()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t012_loc (
    loc_id,
    loc_subtype
  )
select
  w_015.loc_id,
  w_015.loc_subtype
from
  dev_demo_il.w_015_address as w_015
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m012_loc_hist('sp_md_m012_loc');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m012_loc', 'dev_demo_il');
END TRANSACTION;


