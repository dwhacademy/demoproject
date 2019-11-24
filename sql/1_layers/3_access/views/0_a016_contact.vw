BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a016_contact as
select
    A.contact_id
    , A.contact_type
    , A.contact_txt
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v016_contact A
;
CALL dev_demo_ml.sp_deployment_objects('a016_contact','dev_demo_al');
END TRANSACTION;
