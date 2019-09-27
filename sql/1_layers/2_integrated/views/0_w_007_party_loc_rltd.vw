BEGIN TRANSACTION;
create or replace view dev_demo_il.w_007_party_loc_rltd as

select
    k006.party_id as party_id,
    k012.loc_id as loc_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.customers as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k012_loc_key k012
      on cast(a.street||'#'||a.zip_code as varchar(255)) = k012.loc_src_key
      and k012.loc_src_pfx = 'Address'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Address'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k012.loc_id as loc_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.branches as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.branch_name = k006.party_src_key
      and k006.party_src_pfx = 'Organization'
    inner join
      dev_demo_il.k012_loc_key k012
      on cast(a.street||'#'||a.zip_code as varchar(255)) = k012.loc_src_key
      and k012.loc_src_pfx = 'Address'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Address'

group by 1,2,3
;
CALL dev_demo_ml.sp_deployment_objects('w_007_party_loc_rltd', 'dev_demo_il');
END TRANSACTION;

