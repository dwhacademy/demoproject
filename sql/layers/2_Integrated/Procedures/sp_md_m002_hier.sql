CREATE OR REPLACE PROCEDURE demo_il.sp_md_m002_hier()
LANGUAGE plpgsql
AS $$
BEGIN

--DELETE TABLE
DELETE FROM demo_il.m002_hier
;
--INSERT SCRIPTS
INSERT INTO demo_il.m002_hier(hier_cd, hier_nm) VALUES(1, 'Product_Group')
;
END
$$;
