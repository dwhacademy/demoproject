CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_m004_prod()
LANGUAGE plpgsql
AS $$
BEGIN
delete from dev_demo_il.m004_prod;
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
END
$$;
