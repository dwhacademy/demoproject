BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_load_il()
LANGUAGE plpgsql
AS $$
BEGIN

call dev_demo_il.sp_md_m002_hier();
call dev_demo_il.sp_md_k001_hier_item_key();
call dev_demo_il.sp_md_m001_hier_item();
call dev_demo_il.sp_md_m003_hier_item_rltd();
call dev_demo_il.sp_md_k004_prod_key();
call dev_demo_il.sp_md_m004_prod();
call dev_demo_il.sp_md_m005_hier_item_prod_rltd();

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_il', 'dev_demo_il');
END TRANSACTION;

