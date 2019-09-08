BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m004_prod()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_INS_CNT INTEGER;
DECLARE V_UPD_CNT INTEGER;
DECLARE V_DEL_CNT INTEGER;;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_il.m004_prod;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_DEL_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m004_prod', 'm004_prod','delete', V_DEL_CNT);
insert into
  dev_demo_il.m004_prod (
    prod_id,
    prod_cd,
    prod_nm,
    model_year,
    price
  )
select
  w_004.prod_id,
  w_004.prod_cd,
  w_004.prod_nm,
  w_004.model_year,
  w_004.price
from
  dev_demo_il.w_004_prod as w_004
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_INS_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_m004_prod', 'm004_prod','insert', V_INS_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m004_prod', 'dev_demo_il');
END TRANSACTION;


