BEGIN TRANSACTION;
create or replace view dev_demo_il.w_005_hier_item_prod_rltd as

-- prod - hier lvl1
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl1 <> 'N/A'
  and b.lvl2 = 'N/A'

union
-- prod - hier lvl2
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl2 <> 'N/A'
  and b.lvl3 = 'N/A'

union
-- prod - hier lvl3
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl3 <> 'N/A'
  and b.lvl4 = 'N/A'

union
-- prod - hier lvl4
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl4 <> 'N/A'
  and b.lvl5 = 'N/A'

union
-- prod - hier lvl5
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4|| '#' || b.lvl5 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl5 <> 'N/A'
  and b.lvl6 = 'N/A'

union
-- prod - hier lvl6
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4|| '#' || b.lvl5|| '#' || b.lvl6 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl6 <> 'N/A'
  and b.lvl7 = 'N/A'

union
-- prod - hier lvl7
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4|| '#' || b.lvl5|| '#' || b.lvl6|| '#' || b.lvl7 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl7 <> 'N/A'
  and b.lvl8 = 'N/A'

union
-- prod - hier lvl8
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4|| '#' || b.lvl5|| '#' || b.lvl6|| '#' || b.lvl7|| '#' || b.lvl8 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl8 <> 'N/A'
  and b.lvl9 = 'N/A'

union
-- prod - hier lvl9
select
  k001.hier_item_id,
  k004.prod_id
from
  dev_demo_sl.products a
  inner join
    dev_demo_sl.products_tree_unq b
    on a.node_id = b.node_id
  inner join
    dev_demo_il.k001_hier_item_key k001
    on b.lvl1 || '#' || b.lvl2|| '#' || b.lvl3|| '#' || b.lvl4|| '#' || b.lvl5|| '#' || b.lvl6|| '#' || b.lvl7|| '#' || b.lvl8|| '#' || b.lvl9 = k001.hier_item_src_key
  inner join dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key
where
  b.lvl9 <> 'N/A'
;

CALL dev_demo_ml.sp_deployment_objects('w_005_hier_item_prod_rltd', 'dev_demo_il');
END TRANSACTION;

