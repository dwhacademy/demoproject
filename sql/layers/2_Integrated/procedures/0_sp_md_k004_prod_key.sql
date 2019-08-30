CREATE OR REPLACE PROCEDURE demo_il.sp_md_k004_prod_key()
LANGUAGE plpgsql
AS $$
BEGIN
insert into
  demo_il.k004_prod_key (
    prod_id,
    prod_src_pfx,
    prod_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_004.prod_src_key) + coalesce(max(k004.prod_id),1000000) as prod_id,
  w_004.prod_src_pfx,
  w_004.prod_src_key,
  w_004.src_syst_id --source code for master data
from
  demo_il.w_004_prod w_004
left join demo_il.k004_prod_key k004
  on 1=1
where
  w_004.prod_id is null
group by w_004.prod_src_pfx, w_004.prod_src_key,  w_004.src_syst_id
;
END
$$;