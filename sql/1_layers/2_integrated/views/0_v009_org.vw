BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v009_org as
select
    party_id
    , org_nm
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m009_org
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v009_org','dev_demo_il');
END TRANSACTION;
