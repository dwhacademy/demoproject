BEGIN TRANSACTION;
 
create or replace view dev_demo_al.a001_hier_item as
select
    A.hier_item_id
    , A.hier_item_nm
    , A.lvl
    , A.hier_cd
    , A.dw_start_dttm
    , A.dw_end_dttm
from
    dev_demo_il.v001_hier_item A
;
CALL dev_demo_ml.sp_deployment_objects('a001_hier_item','dev_demo_al');
END TRANSACTION;
