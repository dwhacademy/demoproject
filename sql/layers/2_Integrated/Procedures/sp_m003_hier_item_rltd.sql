CREATE OR REPLACE PROCEDURE demo_il.sp_md_m003_hier_item_rltd()
LANGUAGE plpgsql
AS $$
BEGIN
delete from demo_il.m003_hier_item_rltd;
insert into
  demo_il.m003_hier_item_rltd (
    parent_hier_item_id,
    child_hier_item_id
  )

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl1 = m001_p.hier_item_nm
    and m001_p.lvl = 1
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl2 = m001_c.hier_item_nm
    and m001_c.lvl = 2
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl2 = m001_p.hier_item_nm
    and m001_p.lvl = 2
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl3 = m001_c.hier_item_nm
    and m001_c.lvl = 3
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl3 = m001_p.hier_item_nm
    and m001_p.lvl = 3
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl4 = m001_c.hier_item_nm
    and m001_c.lvl = 4
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl4 = m001_p.hier_item_nm
    and m001_p.lvl = 4
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl5 = m001_c.hier_item_nm
    and m001_c.lvl = 5
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl5 = m001_p.hier_item_nm
    and m001_p.lvl = 5
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl6 = m001_c.hier_item_nm
    and m001_c.lvl = 6
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl6 = m001_p.hier_item_nm
    and m001_p.lvl = 6
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl7 = m001_c.hier_item_nm
    and m001_c.lvl = 7
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl7 = m001_p.hier_item_nm
    and m001_p.lvl = 7
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl8 = m001_c.hier_item_nm
    and m001_c.lvl = 8
group by 1,2

union

select
m001_p.hier_item_id as parent_hier_item_id,
m001_c.hier_item_id as child_hier_item_id
from
demo_sl.products_tree_unq as a
inner join
    demo_il.m001_hier_item m001_p
    on a.lvl8 = m001_p.hier_item_nm
    and m001_p.lvl = 8
inner join
    demo_il.m001_hier_item m001_c
    on a.lvl9 = m001_c.hier_item_nm
    and m001_c.lvl = 9
group by 1,2

;
END
$$;