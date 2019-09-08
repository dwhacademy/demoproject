BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m001_hier_item()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_UPD_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m001_hier_item;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_UPD_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m001_hier_item', 'm001_hier_item','delete', V_UPD_CNT);
insert into
  dev_demo_il.m001_hier_item (
    hier_item_id,
    hier_item_nm,
    lvl,
    hier_cd
  )
select
  w_001.hier_item_id,
  w_001.hier_item_nm,
  w_001.lvl,
  w_001.hier_cd
from
  dev_demo_il.w_001_hier_item as w_001

;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_UPD_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m001_hier_item', 'm001_hier_item','insert', V_UPD_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m001_hier_item', 'dev_demo_il');
END TRANSACTION;


