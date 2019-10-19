BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m001_hier_item()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t001_hier_item (
    hier_item_id,
    hier_item_nm,
    lvl,
    hier_cd,
    hier_item_src_pfx,
    hier_item_src_key,
    src_syst_id
  )
select
  w_001.hier_item_id,
  w_001.hier_item_nm,
  w_001.lvl,
  w_001.hier_cd,
  w_001.hier_item_src_pfx,
  w_001.ier_item_src_key,
  w_001.src_syst_id
from
  dev_demo_il.w_001_hier_item as w_001

;
/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m001_hier_item_hist('sp_md_m001_hier_item');

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m001_hier_item', 'dev_demo_il');
END TRANSACTION;


