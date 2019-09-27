BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m003_hier_item_rltd()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m003_hier_item_rltd;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m003_hier_item_rltd', 'm003_hier_item_rltd','delete', V_AFF_CNT);

insert into
  dev_demo_il.m003_hier_item_rltd (
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
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m003_hier_item_rltd', 'm003_hier_item_rltd','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m003_hier_item_rltd', 'dev_demo_il');
END TRANSACTION;

