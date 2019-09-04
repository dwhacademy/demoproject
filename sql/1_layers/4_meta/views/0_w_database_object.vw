BEGIN TRANSACTION;
create or replace view dev_demo_ml.w_database_object as

SELECT
    tablename AS object_nm
    ,schemaname AS schema_nm
    ,'table' as object_type
FROM
    pg_tables
WHERE 
    schemaname in ('dev_demo_sl','dev_demo_il','dev_demo_al','dev_demo_ml')
UNION ALL
SELECT
    viewname AS object_nm
    ,schemaname AS schema_nm
    ,'view'  as object_type
FROM
    pg_views
WHERE 
    schemaname in ('dev_demo_sl','dev_demo_il','dev_demo_al','dev_demo_ml')    
UNION ALL
SELECT
    pg_proc.proname AS object_nm
    ,pg_namespace.nspname AS schema_nm
    ,'procedure' as object_type
FROM
    pg_proc
INNER JOIN
    pg_namespace
    ON pg_proc.pronamespace = pg_namespace.oid
WHERE 
    pg_namespace.nspname in ('dev_demo_sl','dev_demo_il','dev_demo_al','dev_demo_ml')  


;
CALL dev_demo_ml.sp_deployment_objects('w_database_object', 'dev_demo_ml');
END TRANSACTION;

