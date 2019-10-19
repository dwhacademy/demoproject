BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m015_address()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t015_address (
    loc_id,
    street,
    city,
    state,
    zip_cd
  )
select
  w_015.loc_id,
  w_015.street,
  w_015.city,
  w_015.state,
  w_015.zip_cd
from
  dev_demo_il.w_015_address as w_015
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m015_address_hist('sp_md_m015_address');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m015_address', 'dev_demo_il');
END TRANSACTION;


