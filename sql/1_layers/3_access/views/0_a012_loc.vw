BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a012_loc as
select
    A.loc_id
    , A.loc_subtype
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v012_loc A
;
CALL dev_demo_ml.sp_deployment_objects('a012_loc','dev_demo_al');
END TRANSACTION;
