BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k004_prod_key()
LANGUAGE plpgsql
AS $$
BEGIN
insert into
  dev_demo_il.k004_prod_key (
    prod_id,
    prod_src_pfx,
    prod_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_004.prod_src_key) + k004.last_sk as prod_id,
  w_004.prod_src_pfx,
  w_004.prod_src_key,
  w_004.src_syst_id --source code for master data
from
  demo_il.w_004_prod w_004
cross join
  (select coalesce(max(prod_id),1000000) as last_sk from demo_il.k004_prod_key) k004
where
  w_004.prod_id is null
group by w_004.prod_src_pfx, w_004.prod_src_key,  w_004.src_syst_id, k004.last_sk

;
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k004_prod_key', 'dev_demo_il');
END TRANSACTION;

