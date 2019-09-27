BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m008_indiv()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m008_indiv;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m008_indiv', 'm008_indiv','delete', V_AFF_CNT);
insert into
  dev_demo_il.m008_indiv (
    party_id,
    first_nm,
    last_nm,
    active_flag
  )
select
  w_008.party_id,
  w_008.first_nm,
  w_008.last_nm,
  w_008.active_flag
from
  dev_demo_il.w_008_indiv as w_008
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m008_indiv', 'm008_indiv','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m008_indiv', 'dev_demo_il');
END TRANSACTION;


