BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m010_rel_type()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 

--DELETE TABLE
DELETE FROM dev_demo_il.m010_rel_type;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m010_rel_type', 'm010_rel_type','delete', V_AFF_CNT);

--INSERT SCRIPTS
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(1, 'Party - Address');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(2, 'Party - Contact');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(3, 'Manager - Employee');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(4, 'Branch - Employee');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(5, 'Order - Employee');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(6, 'Order - Customer');
INSERT INTO dev_demo_il.m010_rel_type(rel_cd, rel_nm) VALUES(7, 'Order - Branch');

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m010_rel_type', 'm010_rel_type','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m010_rel_type', 'dev_demo_il');
END TRANSACTION;

