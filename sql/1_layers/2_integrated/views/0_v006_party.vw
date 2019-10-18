BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v006_party as
select
    party_id
    , party_subtype
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m006_party
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v006_party','dev_demo_il');
END TRANSACTION;
