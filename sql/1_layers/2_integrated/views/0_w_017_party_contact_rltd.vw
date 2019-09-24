BEGIN TRANSACTION;
create or replace view dev_demo_il.w_017_party_contact_rltd as

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.branches as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.branch_name = k006.party_src_key
      and k006.party_src_pfx = 'Organization'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.branches as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.branch_name = k006.party_src_key
      and k006.party_src_pfx = 'Organization'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.customers as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.customers as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.employees as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.phone as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Phone'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

union

select
    k006.party_id as party_id,
    k016.contact_id as contact_id,
    m010.rel_cd as rel_cd
from
    dev_demo_sl.employees as a
    inner join
      dev_demo_il.k006_party_key k006
      on a.first_name||'#'||a.last_name = k006.party_src_key
      and k006.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k016_contact_key k016
      on cast(a.email as varchar(255)) = k016.contact_src_key
      and k016.contact_src_pfx = 'Email'
    inner join
      dev_demo_il.m010_rel_type m010
      on m010.rel_nm = 'Party - Contact'

group by 1,2,3

;
CALL dev_demo_ml.sp_deployment_objects('w_017_party_contact_rltd', 'dev_demo_il');
END TRANSACTION;

