BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_load_al()
LANGUAGE plpgsql
AS $$
BEGIN

call dev_demo_al.sp_dim_customer();
call dev_demo_al.sp_dim_employee();
call dev_demo_al.sp_fact_orders();


END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_al', 'dev_demo_al');
END TRANSACTION;

