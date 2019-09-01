BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS dev_demo_ml.deployment_objects (
	deployment_dttm TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	object_nm VARCHAR (255) NOT NULL,
	schema_nm VARCHAR (255) NOT NULL,
	PRIMARY KEY (deployment_dttm,object_nm,schema_nm)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default
;

CREATE TABLE IF NOT EXISTS dev_demo_ml.deployment (
	deployment_id SERIAL,
	branch_nm VARCHAR (255) NOT NULL,
	user_nm VARCHAR (255) NOT NULL,
	start_dttm TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
	end_dttm TIMESTAMP WITH TIME ZONE DEFAULT NULL,
	PRIMARY KEY (deployment_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default
;

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
CALL dev_demo_ml.sp_deployment_objects('sp_deployment_objects', 'dev_demo_ml');
CALL dev_demo_ml.sp_deployment_objects('deployment_objects', 'dev_demo_ml');
CALL dev_demo_ml.sp_deployment_objects('deployment', 'dev_demo_ml');

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

CALL dev_demo_ml.sp_deployment_objects('sp_deployment_start', 'dev_demo_ml');
call dev_demo_ml.sp_deployment_start();

END TRANSACTION;
