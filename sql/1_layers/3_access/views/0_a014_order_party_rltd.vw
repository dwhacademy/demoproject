BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a014_order_party_rltd as
select
    A.order_id
    , A.party_id
    , A.rel_cd
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v014_order_party_rltd A
;
CALL dev_demo_ml.sp_deployment_objects('a014_order_party_rltd','dev_demo_al');
END TRANSACTION;
