BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_erp_m013_order()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t013_order;
insert into
  dev_demo_il.t013_order (
    order_id,
    order_cd,
    order_start_dttm,
    order_due_dttm,
    order_complete_dttm,
    status,
    order_src_pfx,
    order_src_key,
    src_syst_id
  )
select
  w_013.order_id,
  w_013.order_cd,
  w_013.order_start_dttm,
  w_013.order_due_dttm,
  w_013.order_complete_dttm,
  w_013.status,
  w_013.order_src_pfx,
  w_013.order_src_key,
  w_013.src_syst_id

from
  dev_demo_il.w_013_order as w_013
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m013_order_hist('sp_erp_m013_order');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_erp_m013_order', 'dev_demo_il');
END TRANSACTION;


