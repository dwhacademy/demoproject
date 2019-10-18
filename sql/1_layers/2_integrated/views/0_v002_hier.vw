BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v002_hier as
select
    hier_cd
    , hier_nm
from
    dev_demo_il.m002_hier
;
CALL dev_demo_ml.sp_deployment_objects('v002_hier','dev_demo_il');
END TRANSACTION;
