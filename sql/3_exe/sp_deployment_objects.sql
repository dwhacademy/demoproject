CREATE OR REPLACE PROCEDURE dev_demo_ml.sp_deployment_objects(a VARCHAR(255), b VARCHAR(255))
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO
    dev_demo_ml.deployment_objects (
        object_nm
        ,schema_nm)
VALUES (
    a
    ,b)
;
END
$$;
