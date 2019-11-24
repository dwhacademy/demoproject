BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a002_hier as
select
    A.hier_cd
    , A.hier_nm
from
    dev_demo_il.v002_hier A
;
CALL dev_demo_ml.sp_deployment_objects('a002_hier','dev_demo_al');
END TRANSACTION;
