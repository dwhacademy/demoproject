BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a010_rel_type as
select
    A.rel_cd
    , A.rel_nm
from
    dev_demo_il.v010_rel_type A
;
CALL dev_demo_ml.sp_deployment_objects('a010_rel_type','dev_demo_al');
END TRANSACTION;
