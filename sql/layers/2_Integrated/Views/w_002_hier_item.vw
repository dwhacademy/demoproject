create or replace view demo_il.w_002_hier_item as

select
  k001.hier_item_id,
  a.lvl1 as hier_item_nm,
  1 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl1 <> 'N/A' and lvl2 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl2 as hier_item_nm,
  2 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl2 <> 'N/A' and lvl3 = 'N/A'

UNION

select
  k001.hier_item_id,
  a.lvl3 as hier_item_nm,
  3 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl3 <> 'N/A' and lvl4 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl4 as hier_item_nm,
  4 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl4 <> 'N/A' and lvl5 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl5 as hier_item_nm,
  5 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl5 <> 'N/A' and lvl6 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl6 as hier_item_nm,
  6 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl6 <> 'N/A' and lvl7 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl7 as hier_item_nm,
  7 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl7 <> 'N/A' and lvl8 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl8 as hier_item_nm,
  8 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl8 <> 'N/A' and lvl9 = 'N/A'

  UNION

select
  k001.hier_item_id,
  a.lvl8 as hier_item_nm,
  9 as lvl,
  m002.hier_cd as hier_cd,
  'Product_Group' as hier_item_src_pfx,
  a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8||'#'||a.lvl9 as hier_item_src_key,
  1 as src_syst_id --source code for master data
from
  demo_sl.products_tree_unq as a
  left join
    demo_il.k001_hier_item_key k001
    on a.lvl1||'#'||a.lvl2||'#'||a.lvl3||'#'||a.lvl4||'#'||a.lvl5||'#'||a.lvl6||'#'||a.lvl7||'#'||a.lvl8||'#'||a.lvl9 = k001.hier_item_src_key
    and k001.hier_item_src_pfx = 'Product_Group'
  inner join
    demo_il.m002_hier m002
    on m002.hier_nm = 'Product_Group'
where
  lvl9 <> 'N/A'

;
