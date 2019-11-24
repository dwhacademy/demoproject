BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v017_party_contact_rltd as
select
    party_id
    , relation_nm
    , contact_id
    , phone
    , rel_cd
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m017_party_contact_rltd
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v017_party_contact_rltd','dev_demo_il');
END TRANSACTION;
