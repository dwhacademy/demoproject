BEGIN TRANSACTION;
create or replace view dev_demo_al.w_dim_store as

select
    m006.party_id as store_id,
    m009.org_nm as store_nm,
    coalesce(m017_p.contact_txt, '-1') as phone,
    coalesce(m017_e.contact_txt, '-1') as email,
    coalesce(m015.city, '-1') as city,
    coalesce(m015.state, '-1') as state
from
    dev_demo_il.m006_party as m006
    inner join
      dev_demo_il.m009_org m009
      on m006.party_id = m009.party_id
    inner join
      (select party_id, rel_cd from dev_demo_il.m014_order_party_rltd group by 1,2) m014 
      on m006.party_id = m014.party_id
      and m014.rel_cd = 7 --Order - Branch
    left join
        (select party_id, contact_txt 
        from 
            dev_demo_il.m017_party_contact_rltd m017
            inner join
                dev_demo_il.m016_contact m016
                on m017.contact_id = m016.contact_id
                and m016.contact_type = 'Phone'
              where  
                m017.rel_cd = 2 --Party - Contact
        ) m017_p
          on m006.party_id = m017_p.party_id
    left join
        (select party_id, contact_txt 
        from 
            dev_demo_il.m017_party_contact_rltd m017
            inner join
                dev_demo_il.m016_contact m016
                on m017.contact_id = m016.contact_id
                and m016.contact_type = 'Email'
            where  
              m017.rel_cd = 2 --Party - Contact
        ) m017_e
          on m006.party_id = m017_e.party_id
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

CALL dev_demo_ml.sp_deployment_objects('w_dim_store', 'dev_demo_al');
END TRANSACTION;

