BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a004_prod as
select
    A.prod_id
    , A.prod_cd
    , A.prod_nm
    , A.model_year
    , A.price
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v004_prod A
;
CALL dev_demo_ml.sp_deployment_objects('a004_prod','dev_demo_al');
END TRANSACTION;
