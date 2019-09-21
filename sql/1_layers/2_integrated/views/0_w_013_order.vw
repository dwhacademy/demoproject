BEGIN TRANSACTION;
create or replace view dev_demo_il.w_013_order as

select
  k013.order_id as order_id,
  a.order_id as order_cd,
  cast(a.order_date as timestamp(0)) as order_start_dttm,
  cast(a.required_date as timestamp(0)) as order_due_dttm,
  cast(a.shipped_date as timestamp(0)) as order_complete_dttm,
  a.order_status as status,
  'N/A' as order_src_pfx,
  a.order_id as order_src_key,
  2 as src_syst_id --source code for Store ERP
from
  dev_demo_sl.orders as a
  left join
    dev_demo_il.k013_order_key k013
    on cast(a.order_id as varchar(255)) = k013.order_src_key

group by 1,2,3,4,5,6,7,8,9
;
CALL dev_demo_ml.sp_deployment_objects('w_013_order', 'dev_demo_il');
END TRANSACTION;

