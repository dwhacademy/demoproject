BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a008_indiv as
select
    A.party_id
    , A.first_nm
    , A.last_nm
    , A.active_flag
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v008_indiv A
;
CALL dev_demo_ml.sp_deployment_objects('a008_indiv','dev_demo_al');
END TRANSACTION;
