BEGIN TRANSACTION;

CREATE OR REPLACE VIEW dev_demo_al.fact_orders AS
SELECT
    *
FROM
    dev_demo_al.t_fact_orders
WHERE 
    load_id = (SELECT MAX(load_id) FROM dev_demo_al.t_fact_orders)
;

CALL dev_demo_ml.sp_deployment_objects('fact_orders', 'dev_demo_al');
END TRANSACTION;