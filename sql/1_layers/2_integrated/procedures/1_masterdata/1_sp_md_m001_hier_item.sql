BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m001_hier_item
(
IN V_LOAD_ID INTEGER, 
INOUT STATUS VARCHAR(50), 
INOUT STEP_NM VARCHAR(50), 
INOUT V_SQLERRM VARCHAR(50), 
INOUT V_SQLSTATE VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE V_AFF_CNT INTEGER;
DECLARE Step VARCHAR(255);
DECLARE SQL_Error VARCHAR(255);
DECLARE SQL_State VARCHAR(255);
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
STEP_NM := 'delete';
delete from dev_demo_il.t001_hier_item;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_md_m001_hier_item', CURRENT_TIMESTAMP, 'IL', 't001_hier_item',STEP_NM, V_AFF_CNT);

STEP_NM := 'insert';
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
  w_001.hier_item_src_key,
  w_001.src_syst_id
from
  dev_demo_il.w_001_hier_item as w_001
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.load_actv VALUES(V_LOAD_ID, 'sp_md_m001_hier_item', CURRENT_TIMESTAMP, 'IL', 't001_hier_item',STEP_NM, V_AFF_CNT);

/********************************************
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m001_hier_item_hist(V_Load_ID, Status, Step, SQL_Error, SQL_State);
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'sp_m001_hier_item_hist', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'IL', Status);

STATUS := 'Success';
EXCEPTION WHEN OTHERS THEN
    STATUS := 'Failure';
    V_SQLERRM := SQLERRM;
    V_SQLSTATE := SQLSTATE;

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m001_hier_item', 'dev_demo_il');
END TRANSACTION;


