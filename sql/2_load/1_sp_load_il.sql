CREATE OR REPLACE PROCEDURE dev_demo_il.sp_load_il()
LANGUAGE plpgsql
AS $$
BEGIN

call dev_demo_il.sp_md_m002_hier();
call dev_demo_il.sp_md_k001_hier_item_key();
call dev_demo_il.sp_md_m001_hier_item();
call dev_demo_il.sp_md_m003_hier_item_rltd();

END
$$;