BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v014_order_party_rltd as
select
    order_id
    , party_id
    , rel_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m014_order_party_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v014_order_party_rltd','dev_demo_il');
END TRANSACTION;