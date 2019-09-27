BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_erp_m014_order_party_rltd()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m014_order_party_rltd;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_erp_m014_order_party_rltd', 'm014_order_party_rltd','delete', V_AFF_CNT);
insert into
  dev_demo_il.m014_order_party_rltd (
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
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_erp_m014_order_party_rltd', 'm014_order_party_rltd','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_erp_m014_order_party_rltd', 'dev_demo_il');
END TRANSACTION;


