BEGIN TRANSACTION;
create or replace view dev_demo_il.w_004_prod as

select
  k004.prod_id as prod_id,
  a.product_id as prod_cd,
  a.product_name as prod_nm,
  a.model_year as model_year,
  a.list_price as price,
  'N/A' as prod_src_pfx,
  a.product_id as prod_src_key,
  1 as src_syst_id --source code for master data
from
  dev_demo_sl.products as a
  left join
    dev_demo_il.k004_prod_key k004
    on cast(a.product_id as varchar(255)) = k004.prod_src_key

group by 1,2,3,4,5,6,7,8
;
CALL dev_demo_ml.sp_deployment_objects('w_004_prod', 'dev_demo_il');
END TRANSACTION;

