BEGIN TRANSACTION;
create or replace view dev_demo_al.w_dim_customer as

select
    m006.party_id as customer_id,
    m008.first_nm||' '||m008.last_nm as customer_nm,
    coalesce(m016_p.contact_txt, '-1') as phone,
    coalesce(m016_e.contact_txt, '-1') as email,
    coalesce(m015.city, '-1') as city,
    coalesce(m015.state, '-1') as state
from
    dev_demo_il.m006_party as m006
    inner join
      dev_demo_il.m008_indiv m008
      on m006.party_id = m008.party_id
    inner join
      (select party_id, rel_cd from dev_demo_il.m014_order_party_rltd group by 1,2) m014 
      on m006.party_id = m014.party_id
      and m014.rel_cd = 6 --Order - Customer
    left join
      dev_demo_il.m017_party_contact_rltd m017
      on m006.party_id = m017.party_id
      and m017.rel_cd = 2 --Party - Contact
    left join
      dev_demo_il.m016_contact m016_p
      on m017.contact_id = m016_p.contact_id
      and m016_p.contact_type = 'Phone'
    left join
      dev_demo_il.m016_contact m016_e
      on m017.contact_id = m016_e.contact_id
      and m016_e.contact_type = 'Email'
    left join
      dev_demo_il.m007_party_loc_rltd m007
      on m006.party_id = m007.party_id
      and m007.rel_cd = 1 --Party - Address
    left join
      dev_demo_il.m012_loc m012
      on m007.loc_id = m012.loc_id
    left join
      dev_demo_il.m015_address m015
      on m012.loc_id = m015.loc_id

;
CALL dev_demo_ml.sp_deployment_objects('w_dim_customer', 'dev_demo_al');
END TRANSACTION;

