BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a015_address as
select
    A.loc_id
    , A.street
    , A.city
    , A.state
    , A.zip_cd
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v015_address A
;
CALL dev_demo_ml.sp_deployment_objects('a015_address','dev_demo_al');
END TRANSACTION;
