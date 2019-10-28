BEGIN TRANSACTION;

CREATE OR REPLACE VIEW dev_demo_al.dim_customer AS
SELECT
    *
FROM
    dev_demo_al.t_dim_customer
WHERE 
    load_id = (SELECT MAX(load_id) FROM dev_demo_al.t_dim_customer)
;

CALL dev_demo_ml.sp_deployment_objects('dim_customer', 'dev_demo_al');
END TRANSACTION;