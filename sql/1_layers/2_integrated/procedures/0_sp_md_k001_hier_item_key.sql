BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k001_hier_item_key()
LANGUAGE plpgsql
AS $$
BEGIN
insert into
  dev_demo_il.k001_hier_item_key (
    hier_item_id,
    hier_item_src_pfx,
    hier_item_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_001.hier_item_src_key) + coalesce(max(k001.hier_item_id),1000000) as hier_item_id,
  w_001.hier_item_src_pfx,
  w_001.hier_item_src_key,
  w_001.src_syst_id --source code for master data
from
  dev_demo_il.w_001_hier_item w_001
left join dev_demo_il.k001_hier_item_key k001
  on 1=1
where
  w_001.hier_item_id is null
group by w_001.hier_item_src_pfx, w_001.hier_item_src_key,  w_001.src_syst_id
;
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k001_hier_item_key', 'dev_demo_il');
END TRANSACTION;

