CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m003_hier_item_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
delete from dev_demo_il.m003_hier_item_rltd;
insert into
  dev_demo_il.m003_hier_item_rltd (
    parent_hier_item_id,
    child_hier_item_id
  )

--1 ->2
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--2 -> 3
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--3 -> 4
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--4 -> 5
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--5 -> 6
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--6 -> 7
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--7 -> 8
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

union
--8 -> 9
select
k001_p.hier_item_id as parent_hier_item_id,
k001_c.hier_item_id as child_hier_item_id
from
dev_demo_sl.products_tree_unq as a
inner join
    dev_demo_il.k001_hier_item_key k001_p
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8 = k001_p.hier_item_src_key
    and k001_p.hier_item_src_pfx = 'Product_Group'
inner join
    dev_demo_il.k001_hier_item_key k001_c
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8||'#'||a.lvl9 = k001_c.hier_item_src_key
    and k001_c.hier_item_src_pfx = 'Product_Group'
group by 1,2

;
END
$$;