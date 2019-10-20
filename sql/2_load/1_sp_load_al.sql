BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_load_al()
LANGUAGE plpgsql
AS $$
DECLARE V_Load_ID INTEGER;
DECLARE Status VARCHAR(255);
DECLARE Step VARCHAR(255);
DECLARE SQL_Error VARCHAR(255);
DECLARE SQL_State VARCHAR(255);
BEGIN

-- LOAD INIT.
Status := 'Success';
SELECT COALESCE(MAX(load_id)+1,100000) into V_Load_ID  FROM dev_demo_ml.load_stat WHERE proc_nm = 'LOAD_INIT'; 
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'LOAD_INIT', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'AL', Status);

-- sp_dim_prod_hier
call dev_demo_al.sp_dim_prod_hier(Status, Step, SQL_Error, SQL_State);
INSERT INTO dev_demo_ml.load_stat VALUES(V_Load_ID, 'sp_dim_prod_hier', CURRENT_TIMESTAMP, Step, SQL_Error, SQL_State, 'AL', Status);



END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_al', 'dev_demo_al');
END TRANSACTION;