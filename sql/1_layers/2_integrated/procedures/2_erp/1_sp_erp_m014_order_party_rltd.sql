BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_erp_m014_order_party_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t014_order_party_rltd;
insert into
  dev_demo_il.t014_order_party_rltd (
    order_id,
    party_id,
    rel_cd
  )
select
  w_014.order_id,
  w_014.party_id,
  w_014.rel_cd
from
  dev_demo_il.w_014_order_party_rltd as w_014
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m014_order_party_rltd_hist('sp_erp_m014_order_party_rltd');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_erp_m014_order_party_rltd', 'dev_demo_il');
END TRANSACTION;


