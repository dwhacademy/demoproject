BEGIN TRANSACTION;
create or replace view dev_demo_il.w_009_org as

select
    k006.party_id as party_id,
    'Organization' as party_subtype,
    a.branch_id as party_cd,
    a.branch_name as org_nm,
    'Branch' as party_src_pfx,
    a.branch_id as party_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.branches as a
    left join
      dev_demo_il.k006_party_key k006
      on cast(a.branch_id as varchar(255)) = k006.party_src_key
      and k006.party_src_pfx = 'Branch'

group by 1,2,3,4,5,6,7

;
CALL dev_demo_ml.sp_deployment_objects('w_009_org', 'dev_demo_il');
END TRANSACTION;

