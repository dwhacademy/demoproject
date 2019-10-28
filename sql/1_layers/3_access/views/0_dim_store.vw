BEGIN TRANSACTION;

CREATE OR REPLACE VIEW dev_demo_al.dim_store AS
SELECT
    *
FROM
    dev_demo_al.t_dim_store
WHERE 
    load_id = (SELECT MAX(load_id) FROM dev_demo_al.t_dim_store)
;

CALL dev_demo_ml.sp_deployment_objects('dim_store', 'dev_demo_al');
END TRANSACTION;