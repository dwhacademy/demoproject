BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v011_party_rltd as
select
    parent_party_id
    , child_party_id
    , rel_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m011_party_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v011_party_rltd','dev_demo_il');
END TRANSACTION;
