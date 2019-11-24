BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a017_party_contact_rltd as
select
    A.party_id
    , A.relation_nm
    , A.contact_id
    , A.phone
    , A.rel_cd
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v017_party_contact_rltd A
;
CALL dev_demo_ml.sp_deployment_objects('a017_party_contact_rltd','dev_demo_al');
END TRANSACTION;
