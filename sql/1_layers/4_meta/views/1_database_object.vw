BEGIN TRANSACTION;
create or replace view dev_demo_ml.database_object as
SELECT error
    object_nm
    ,schema_nm
    ,object_type
    ,branch_nm
    ,user_nm
    ,deployment_dttm
    ,deployment_ID
FROM
    (SELECT
        A.object_nm
        ,A.schema_nm
        ,A.object_type
        ,C.branch_nm
        ,C.user_nm
        ,B.deployment_dttm
        ,C.deployment_ID
        ,row_number() over (partition by A.object_nm,A.schema_nm,A.object_type order by COALESCE(C.deployment_ID,0) DESC) as seq
    FROM
        dev_demo_ml.w_database_object A
    LEFT JOIN
        dev_demo_ml.deployment_objects B
        ON A.object_nm = B.object_nm
          AND A.schema_nm = B.schema_nm
    LEFT JOIN
        dev_demo_ml.deployment C
        ON B.deployment_dttm BETWEEN C.start_dttm AND C.end_dttm
    ) A
WHERE 
    seq = 1
;
CALL dev_demo_ml.sp_deployment_objects('database_object', 'dev_demo_ml');
END TRANSACTION;

