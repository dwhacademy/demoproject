BEGIN TRANSACTION;
 
create or replace view dev_demo_il.v016_contact as
select
    contact_id
    , contact_type
    , contact_txt
    , dw_start_dttm
    , dw_end_dttm
from
    dev_demo_il.m016_contact
where
    CURRENT_TIMESTAMP(0) BETWEEN dw_start_dttm AND dw_end_dttm
;
CALL dev_demo_ml.sp_deployment_objects('v016_contact','dev_demo_il');
END TRANSACTION;
