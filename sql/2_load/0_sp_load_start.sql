BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_ml.sp_load_start ()
LANGUAGE plpgsql
AS $$
BEGIN

-- CLOSE OLD LOAD IF FAILED
UPDATE 
    dev_demo_ml.load 
SET 
    load_end_dttm = current_timestamp  - interval '1' second,
    load_status = 'FAILURE'
WHERE 
    load_end_dttm IS NULL;

-- LOG NEW LOAD_ID
INSERT INTO dev_demo_ml.load(load_id,load_start_dttm)
SELECT COALESCE(MAX(load_id)+1,100000), current_timestamp  FROM dev_demo_ml.load;

END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_load_start', 'dev_demo_ml');
END TRANSACTION;
