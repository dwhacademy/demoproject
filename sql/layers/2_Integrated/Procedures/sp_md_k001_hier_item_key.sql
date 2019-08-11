CREATE OR REPLACE PROCEDURE demo_il.sp_md_k001_hier_item_key()
LANGUAGE plpgsql
AS $$
BEGIN
insert into
  demo_il.k001_hier_item_key (
    hier_item_id,
    hier_item_src_pfx,
    hier_item_src_key,
    src_syst_id
  )
select
  row_number() over( order by a.node_id) + 1000000 as hier_item_id,
  'Product_Group' as hier_item_src_pfx,
  a.node_id as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq a
  left join
    demo_il.k001_hier_item_key k001
    on cast(a.node_id as varchar(255)) = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
where
  k001.hier_item_id is null
;
END
$$;
