BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a007_party_loc_rltd as
select
    A.party_id
    , A.loc_id
    , A.rel_cd
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v007_party_loc_rltd A
;
CALL dev_demo_ml.sp_deployment_objects('a007_party_loc_rltd','dev_demo_al');
END TRANSACTION;
