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
  w_001.hier_item_id,
  w_001.hier_item_nm,
  w_001.lvl,
  w_001.hier_cd
from
  demo_il.w_001_hier_item as w_001

;
END
$$;
