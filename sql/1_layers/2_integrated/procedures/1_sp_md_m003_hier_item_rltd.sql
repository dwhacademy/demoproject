BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m003_hier_item_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t003_hier_item_rltd (
    parent_hier_item_id,
    child_hier_item_id
  )
select
  w_003.parent_hier_item_id,
  w_003.child_hier_item_id
from
  dev_demo_il.w_003_hier_item_rltd as w_003
;

/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m003_hier_item_rltd_hist('sp_md_m003_hier_item_rltd');

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m003_hier_item_rltd', 'dev_demo_il');
END TRANSACTION;

