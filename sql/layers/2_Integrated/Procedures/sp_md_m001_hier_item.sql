CREATE OR REPLACE PROCEDURE demo_il.sp_md_m001_hier_item()
LANGUAGE plpgsql
AS $$
BEGIN
delete from demo_il.m001_hier_item;
insert into
  demo_il.m001_hier_item (
    hier_item_id,
    hier_item_nm,
    lvl,
    hier_cd
  )
select
  w_002.hier_item_id,
  w_002.hier_item_nm,
  w_002.lvl,
  w_002.hier_cd
from
  demo_il.w_002_hier_item as w_002

;
END
$$;
