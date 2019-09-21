BEGIN TRANSACTION;
create or replace view dev_demo_il.w_016_contact as

select
    k016.contact_id as contact_id,
    'Phone' as contact_type,
    a.phone as contact_txt,
    'Phone' as contact_src_pfx,
    a.phone as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.branches as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'

group by 1,2,3,4,5,6

union 

select
    k016.contact_id as contact_id,
    'Phone' as contact_type,
    a.phone as contact_txt,
    'Phone' as contact_src_pfx,
    a.phone as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.customers as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'

group by 1,2,3,4,5,6

union

select
    k016.contact_id as contact_id,
    'Phone' as contact_type,
    a.phone as contact_txt,
    'Phone' as contact_src_pfx,
    a.phone as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.employees as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'

union

select
    k016.contact_id as contact_id,
    'Email' as contact_type,
    a.email as contact_txt,
    'Email' as contact_src_pfx,
    a.email as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.branches as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'

group by 1,2,3,4,5,6

union 

select
    k016.contact_id as contact_id,
    'Email' as contact_type,
    a.email as contact_txt,
    'Email' as contact_src_pfx,
    a.email as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.customers as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'

group by 1,2,3,4,5,6

union

select
    k016.contact_id as contact_id,
    'Email' as contact_type,
    a.email as contact_txt,
    'Email' as contact_src_pfx,
    a.email as contact_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.employees as a
    left join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'

group by 1,2,3,4,5,6
;
CALL dev_demo_ml.sp_deployment_objects('w_016_contact', 'dev_demo_il');
END TRANSACTION;

