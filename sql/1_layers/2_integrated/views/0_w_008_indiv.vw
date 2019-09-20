BEGIN TRANSACTION;
create or replace view dev_demo_il.w_008_indiv as

select
    k006.party_id as party_id,
    'Individual' as party_subtype,
    a.first_name as first_nm,
    a.last_name as last_nm,
    null as active_flag,
    'Individual' as party_src_pfx,
    a.first_name||'#'||a.last_name as party_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.customers as a
    left join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'

group by 1,2,3,4,5,6,7,8

union

select
    k006.party_id as party_id,
    'Individual' as party_subtype,
    a.first_name as first_nm,
    a.last_name as last_nm,
    case when a.active = '1' then 'Y' else 'N' end as active_flag,
    'Individual' as party_src_pfx,
    a.first_name||'#'||a.last_name as party_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.employees as a
    left join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'

group by 1,2,3,4,5,6,7,8
;
CALL dev_demo_ml.sp_deployment_objects('w_008_indiv', 'dev_demo_il');
END TRANSACTION;

