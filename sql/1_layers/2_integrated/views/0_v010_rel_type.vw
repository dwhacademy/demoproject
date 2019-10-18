BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v010_rel_type as
select
    rel_cd
    , rel_nm
from
    dev_demo_il.m010_rel_type
;
CALL dev_demo_ml.sp_deployment_objects('v010_rel_type','dev_demo_il');
END TRANSACTION;
