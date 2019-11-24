BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m016_contact()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t016_contact;
insert into
  dev_demo_il.t016_contact (
    contact_id,
    contact_type,
    contact_txt,
    contact_src_pfx,
    contact_src_key,
    src_syst_id
  )
select
  w_016.contact_id,
  w_016.contact_type,
  w_016.contact_txt,
  w_016.contact_src_pfx,
  w_016.contact_src_key,
  w_016.src_syst_id
from
  dev_demo_il.w_016_contact as w_016
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m016_contact_hist('sp_md_m016_contact');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m016_contact', 'dev_demo_il');
END TRANSACTION;


