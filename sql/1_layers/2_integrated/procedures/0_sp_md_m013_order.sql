BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m013_order()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m013_order;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m013_order', 'm013_order','delete', V_AFF_CNT);
insert into
  dev_demo_il.m013_order (
    order_id,
    order_cd,
    order_start_dttm,
    order_due_dttm,
    order_complete_dttm,
    status
  )
select
  w_013.order_id,
  w_013.order_cd,
  w_013.order_start_dttm,
  w_013.order_due_dttm,
  w_013.order_complete_dttm,
  w_013.status

from
  dev_demo_il.w_013_order as w_013
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m013_order', 'm013_order','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m013_order', 'dev_demo_il');
END TRANSACTION;


