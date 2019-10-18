BEGIN TRANSACTION;
create or replace view dev_demo_al.w_fact_orders as

select
    a018.prod_id as prod_id,
    a018.order_id as order_id,
    coalesce(a014_c.party_id, -1) as customer_id,
    coalesce(a014_e.party_id, -1) as employee_id,
    coalesce(a014_s.party_id, -1) as store_id,
    a013.order_start_dttm as order_start_dttm,
    a013.order_due_dttm as order_due_dttm,
    a013.order_complete_dttm as order_complete_dttm,
    a013.status as order_status,
    a018.discount as discount,
    sum(a018.price*a018.quantity) as order_amount
from
    dev_demo_il.a018_order_item as a018
    inner join
      dev_demo_il.a013_order a013
      on a018.order_id = a013.order_id
    left join
      dev_demo_il.a014_order_party_rltd a014_c 
      on a013.order_id = a014_c.order_id
      and a014_c.rel_cd = 6 --Order - Customer
    left join
      dev_demo_il.a014_order_party_rltd a014_e 
      on a013.order_id = a014_e.order_id
      and a014_e.rel_cd = 5 --Order - Employee
    left join
      dev_demo_il.a014_order_party_rltd a014_s 
      on a013.order_id = a014_s.order_id
      and a014_s.rel_cd = 7 --Order - Branch

group by 1,2,3,4,5,6,7,8,9,10
;
CALL dev_demo_ml.sp_deployment_objects('w_fact_orders', 'dev_demo_al');
END TRANSACTION;

