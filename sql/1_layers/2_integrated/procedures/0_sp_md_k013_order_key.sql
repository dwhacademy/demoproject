BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k013_order_key()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
insert into
  dev_demo_il.k013_order_key (
    order_id,
    order_src_pfx,
    order_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_013.order_src_key) + k013.last_sk as order_id,
  w_013.order_src_pfx,
  w_013.order_src_key,
  w_013.src_syst_id --source code for master data
from
  dev_demo_il.w_013_order w_013
cross join
  (select coalesce(max(order_id),1000000) as last_sk from dev_demo_il.k013_order_key) k013
where
  w_013.order_id is null
group by w_013.order_src_pfx, w_013.order_src_key,  w_013.src_syst_id, k013.last_sk
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_k013_order_key', 'k013_order_key','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k013_order_key', 'dev_demo_il');
END TRANSACTION;

