BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m005_hier_item_prod_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
delete from
  dev_demo_il.t005_hier_item_prod_rltd;
insert into
  dev_demo_il.t005_hier_item_prod_rltd (
    hier_item_id,
    prod_id
  )
select
  w_005.hier_item_id,
  w_005.prod_id
from
  dev_demo_il.w_005_hier_item_prod_rltd as w_005
;
  
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m005_hier_item_prod_rltd_hist('sp_md_m005_hier_item_prod_rltd');

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m005_hier_item_prod_rltd', 'dev_demo_il');
END TRANSACTION;