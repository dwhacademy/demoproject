BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m005_hier_item_prod_rltd()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m005_hier_item_prod_rltd;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m005_hier_item_prod_rltd', 'm005_hier_item_prod_rltd','delete', V_AFF_CNT);
insert into
  dev_demo_il.m005_hier_item_prod_rltd (
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
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m005_hier_item_prod_rltd', 'm005_hier_item_prod_rltd','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m005_hier_item_prod_rltd', 'dev_demo_il');
END TRANSACTION;