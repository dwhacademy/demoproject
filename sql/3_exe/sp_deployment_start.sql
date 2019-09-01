BEGIN TRANSACTION;

CREATE OR REPLACE PROCEDURE dev_demo_ml.sp_deployment_start()
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO
    dev_demo_ml.deployment (
        branch_nm
        ,user_nm)
VALUES (
    'git_branch_name'
    ,'db_user_name')
;
END
$$;

call dev_demo_ml.sp_deployment_start();
CALL dev_demo_ml.sp_deployment_objects('sp_deployment_start', 'dev_demo_ml');
END TRANSACTION;
