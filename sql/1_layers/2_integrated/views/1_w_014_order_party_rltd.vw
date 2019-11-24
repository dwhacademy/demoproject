BEGIN TRANSACTION;
create or replace view dev_demo_il.w_014_order_party_rltd as

select
    k013.order_id as order_id,
    k006.party_id as party_id,
    v010.rel_cd as rel_cd
from
    dev_demo_sl.orders as a
    inner join
      dev_demo_sl.employees as b
      on a.employee_id = b.employee_id
    inner join
      dev_demo_il.k013_order_key k013
      on cast(a.order_id as varchar(255)) = k013.order_src_key
    inner join
      dev_demo_il.k006_party_key k006
      on b.first_name||'#'||b.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.v010_rel_type v010
      on v010.rel_nm = 'Order - Employee'

group by 1,2,3

union

select
    k013.order_id as order_id,
    k006.party_id as party_id,
    v010.rel_cd as rel_cd
from
    dev_demo_sl.orders as a
    inner join
      dev_demo_sl.customers as b
      on a.customer_id = b.customer_id
    inner join
      dev_demo_il.k013_order_key k013
      on cast(a.order_id as varchar(255)) = k013.order_src_key
    inner join
      dev_demo_il.k006_party_key k006
      on b.first_name||'#'||b.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.v010_rel_type v010
      on v010.rel_nm = 'Order - Customer'

group by 1,2,3

union

select
    k013.order_id as order_id,
    k006.party_id as party_id,
    v010.rel_cd as rel_cd
from
    dev_demo_sl.orders as a
    inner join
      dev_demo_sl.branches as b
      on a.branch_id = b.branch_id
    inner join
      dev_demo_il.k013_order_key k013
      on cast(a.order_id as varchar(255)) = k013.order_src_key
    inner join
      dev_demo_il.k006_party_key k006
      on b.branch_name = k006.party_src_key
      and k006.party_src_pfx = 'Organization'
    inner join
      dev_demo_il.v010_rel_type v010
      on v010.rel_nm = 'Order - Branch'

group by 1,2,3
;

CALL dev_demo_ml.sp_deployment_objects('w_014_order_party_rltd', 'dev_demo_il');
END TRANSACTION;

