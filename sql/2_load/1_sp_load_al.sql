BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_load_al()
LANGUAGE plpgsql
AS $$
DECLARE Load_ID INTEGER;
DECLARE Status VARCHAR(255) DEFAULT 'Success';
BEGIN

-- LOAD INIT.
SET Status = 'Success';
SELECT COALESCE(MAX(load_id)+1,100000) into Load_ID  FROM dev_demo_ml.load_stat WHERE proc_nm = 'LOAD_INIT'; 
INSERT INTO dev_demo_ml.load_stat VALUES(Load_ID, 'LOAD_INIT', CURRENT_TIMESTAMP, 'AL', Status);

BEGIN
  call dev_demo_al.sp_dim_prod_hier();
EXCEPTION WHEN OTHERS THEN
  Status = 'Failure';
END;


call dev_demo_al.sp_dim_customer();
call dev_demo_al.sp_dim_employee();
call dev_demo_al.sp_dim_store();
call dev_demo_al.sp_fact_orders();


END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_al', 'dev_demo_al');
END TRANSACTION;

