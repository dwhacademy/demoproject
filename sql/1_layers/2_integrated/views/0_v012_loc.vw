BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v012_loc as
select
    loc_id
    , loc_subtype
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m012_loc
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v012_loc','dev_demo_il');
END TRANSACTION;

