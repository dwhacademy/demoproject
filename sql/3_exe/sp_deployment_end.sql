BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_ml.sp_deployment_end()
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE
    dev_demo_ml.deployment 
SET 
    end_dttm = current_timestamp
WHERE
    start_dttm = (SELECT MAX(start_dttm) FROM dev_demo_ml.deployment )
;
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_deployment_end', 'dev_demo_ml');
call dev_demo_ml.sp_deployment_end();
END TRANSACTION;

ANALYZE dev_demo_ml.deployment;
ANALYZE dev_demo_ml.deployment_objects;
