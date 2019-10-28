BEGIN TRANSACTION;

CREATE OR REPLACE VIEW dev_demo_al.dim_employee AS
SELECT
    *
FROM
    dev_demo_al.t_dim_employee
WHERE 
    load_id = (SELECT MAX(load_id) FROM dev_demo_al.t_dim_employee)
;

CALL dev_demo_ml.sp_deployment_objects('dim_employee', 'dev_demo_al');
END TRANSACTION;