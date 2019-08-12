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
  row_number() over( order by w_002.hier_item_src_key) + 1000000 as hier_item_id,
  hier_item_src_pfx,
  hier_item_src_key,
  src_syst_id --source code for master data
from
  demo_il.w_002_hier_item w_002

where
  w_002.hier_item_id is null
;
END
$$;