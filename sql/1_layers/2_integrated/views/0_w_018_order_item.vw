BEGIN TRANSACTION;
create or replace view dev_demo_il.w_018_order_item as

select
    k013.order_id as order_id,
    k004.prod_id as prod_id,
    sum(a.quantity) as quantity,
    cast(avg(a.list_price) as decimal(20,2)) as price,
    cast(sum(a.discount*a.quantity)/sum(a.quantity) as decimal(20,2)) as discount
from
    dev_demo_sl.order_items as a
    inner join
      dev_demo_sl.products as b
      on a.product_id = b.product_id
    inner join
      dev_demo_il.k013_order_key k013
      on cast(a.order_id as varchar(255)) = k013.order_src_key
    inner join
      dev_demo_il.k004_prod_key k004
      on cast(b.product_id as varchar(255)) = k004.prod_src_key

group by 1,2
;

CALL dev_demo_ml.sp_deployment_objects('w_018_order_item', 'dev_demo_il');
END TRANSACTION;

