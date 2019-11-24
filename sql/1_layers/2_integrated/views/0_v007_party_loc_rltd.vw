BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v007_party_loc_rltd as
select
    party_id
    , loc_id
    , rel_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m007_party_loc_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v007_party_loc_rltd','dev_demo_il');
END TRANSACTION;
