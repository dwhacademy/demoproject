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
