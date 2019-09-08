BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_ml.sp_load_end ()
LANGUAGE plpgsql
AS $$
BEGIN
--update load
UPDATE 
    dev_demo_ml.load 
SET 
    load_end_dttm = current_timestamp,
    load_status = 'SUCCESS'
FROM
    (SELECT
    	MAX(load_id) load_id
    FROM 
        dev_demo_ml.load
    ) A
WHERE 
    dev_demo_ml.load.load_id = A.load_id
;

ANALYZE dev_demo_ml.load;
ANALYZE dev_demo_ml.log;

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_end', 'dev_demo_ml');
END TRANSACTION;
