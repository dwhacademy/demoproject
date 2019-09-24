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
call dev_demo_il.sp_md_k012_loc_key();
call dev_demo_il.sp_md_m012_loc();
call dev_demo_il.sp_md_m015_address();
call dev_demo_il.sp_md_k016_contact_key();
call dev_demo_il.sp_md_m016_contact();
call dev_demo_il.sp_md_k006_party_key();
call dev_demo_il.sp_md_m006_party();
call dev_demo_il.sp_md_m008_indiv();
call dev_demo_il.sp_md_m009_org();
call dev_demo_il.sp_md_m010_rel_type();
call dev_demo_il.sp_md_k013_order_key();
call dev_demo_il.sp_md_m013_order();
call dev_demo_il.sp_md_m007_party_loc_rltd();
call dev_demo_il.sp_md_m017_party_contact_rltd();
call dev_demo_il.sp_md_m011_party_rltd();


END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_il', 'dev_demo_il');
END TRANSACTION;

