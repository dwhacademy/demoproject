BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a009_org as
select
    A.party_id
    , A.org_nm
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v009_org A
;
CALL dev_demo_ml.sp_deployment_objects('a009_org','dev_demo_al');
END TRANSACTION;
