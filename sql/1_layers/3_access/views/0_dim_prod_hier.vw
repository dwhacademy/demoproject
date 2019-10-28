BEGIN TRANSACTION;

CREATE OR REPLACE VIEW dev_demo_al.dim_prod_hier AS
SELECT
    *
FROM
    dev_demo_al.t_dim_prod_hier
WHERE 
    load_id = (SELECT MAX(load_id) FROM dev_demo_al.t_dim_prod_hier)
;

CALL dev_demo_ml.sp_deployment_objects('dim_prod_hier', 'dev_demo_al');
END TRANSACTION;