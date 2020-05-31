BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_load_il()
LANGUAGE plpgsql
AS $$
DECLARE V_Load_ID INTEGER;
DECLARE Status VARCHAR(255);
DECLARE Step VARCHAR(255);
DECLARE SQL_Error VARCHAR(255);
DECLARE SQL_State VARCHAR(255);
BEGIN
Step := '';

-- LOAD INIT.
Status := 'Success';
SELECT COALESCE(MAX(load_id)+1,100000) into V_Load_ID  FROM dev_demo_ml.load_stat WHERE proc_nm = 'LOAD_INIT'; 
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'LOAD_INIT', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'IL', Status);

-- sp_md_m002_hier
Status := 'Success';
call dev_demo_il.sp_md_m002_hier(V_Load_ID, Status, Step, SQL_Error, SQL_State);
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'sp_md_m002_hier', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'IL', Status);


-- sp_md_m001_hier_item
Status := 'Success';
call dev_demo_il.sp_md_m001_hier_item(V_Load_ID, Status, Step, SQL_Error, SQL_State);
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'sp_md_m001_hier_item', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'IL', Status);

-- LOAD FINAL.
Status := 'Success';
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'LOAD_FINAL', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'IL', Status);



/*
call dev_demo_il.sp_md_m003_hier_item_rltd();
call dev_demo_il.sp_md_m004_prod();
call dev_demo_il.sp_md_m005_hier_item_prod_rltd();
call dev_demo_il.sp_md_m012_loc();
call dev_demo_il.sp_md_m015_address();
call dev_demo_il.sp_md_m016_contact();
call dev_demo_il.sp_md_m006_party();
call dev_demo_il.sp_md_m008_indiv();
call dev_demo_il.sp_md_m009_org();
call dev_demo_il.sp_md_m010_rel_type();
call dev_demo_il.sp_md_m007_party_loc_rltd();
call dev_demo_il.sp_md_m017_party_contact_rltd();
call dev_demo_il.sp_md_m011_party_rltd();
call dev_demo_il.sp_erp_m013_order();
call dev_demo_il.sp_erp_m014_order_party_rltd();
call dev_demo_il.sp_erp_m018_order_item();
*/

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_il', 'dev_demo_il');
END TRANSACTION;

