BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a006_party as
select
    A.party_id
    , A.party_subtype
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v006_party A
;
CALL dev_demo_ml.sp_deployment_objects('a006_party','dev_demo_al');
END TRANSACTION;
