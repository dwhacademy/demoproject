CREATE OR REPLACE PROCEDURE demo_il.sp_load_il()
LANGUAGE plpgsql
AS $$
BEGIN

call demo_il.sp_md_m002_hier();
call demo_il.sp_md_k001_hier_item_key();
call demo_il.sp_md_m001_hier_item();
call demo_il.sp_md_m003_hier_item_rltd();
call demo_il.sp_md_m004_prod_key();
call demo_il.sp_md_m004_prod();
call demo_il.sp_md_m005_hier_item_prod_rltd();

END
$$;