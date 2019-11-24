BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v008_indiv as
select
    party_id
    , first_nm
    , last_nm
    , active_flag
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m008_indiv
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v008_indiv','dev_demo_il');
END TRANSACTION;
