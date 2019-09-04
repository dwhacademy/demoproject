BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m002_hier()
LANGUAGE plpgsql
AS $$
BEGIN

--DELETE TABLE
DELETE FROM dev_demo_il.m002_hier
;
--INSERT SCRIPTS
INSERT INTO dev_demo_il.m002_hier(hier_cd, hier_nm) VALUES(1, 'Product_Group')
;
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_m002_hier', 'dev_demo_il');
END TRANSACTION;

