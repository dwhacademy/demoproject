BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m004_prod()
LANGUAGE plpgsql
AS $$
BEGIN
/********************************************
 * MOVING DATA INTO TEMP TABLE
********************************************/
insert into
  dev_demo_il.t004_prod (
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
 * HISTORIZE TARGET TABLE
********************************************/
CALL dev_demo_il.sp_m004_prod_hist('sp_md_m004_prod');

END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_md_m004_prod', 'dev_demo_il');
END TRANSACTION;


