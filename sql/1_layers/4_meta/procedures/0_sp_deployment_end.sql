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
