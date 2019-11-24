BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v015_address as
select
    loc_id
    , street
    , city
    , state
    , zip_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m015_address
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v015_address','dev_demo_il');
END TRANSACTION;
