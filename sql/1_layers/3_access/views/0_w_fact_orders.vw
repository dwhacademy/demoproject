BEGIN TRANSACTION;
create or replace view dev_demo_al.w_fact_orders as

select
    m018.prod_id as prod_id,
    m018.order_id as order_id,
    coalesce(m014_c.party_id, -1) as customer_id,
    coalesce(m014_e.party_id, -1) as employee_id,
    coalesce(m014_s.party_id, -1) as store_id,
    m013.order_start_dttm as order_start_dttm,
    m013.order_due_dttm as order_due_dttm,
    m013.order_complete_dttm as order_complete_dttm,
    m013.status as order_status,
    m018.discount as discount,
    m018.price*m018.quantity as order_amount
from
    dev_demo_il.m018_order_item as m018
    inner join
      dev_demo_il.m013_order m013
      on m018.order_id = m013.order_id
    left join
      dev_demo_il.m014_order_party_rltd m014_c 
      on m013.order_id = m014_c.order_id
      and m014_c.rel_cd = 6 --Order - Customer
    left join
      dev_demo_il.m014_order_party_rltd m014_e 
      on m013.order_id = m014_e.order_id
      and m014_e.rel_cd = 5 --Order - Employee
    left join
      dev_demo_il.m014_order_party_rltd m014_s 
      on m013.order_id = m014_s.order_id
      and m014_s.rel_cd = 7 --Order - Branch

;
CALL dev_demo_ml.sp_deployment_objects('w_fact_orders', 'dev_demo_al');
END TRANSACTION;

