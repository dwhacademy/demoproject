BEGIN TRANSACTION;
create or replace view dev_demo_al.w_dim_employee as

select
    m006.party_id as employee_id,
    m008.first_nm||' '||m008.last_nm as employee_nm,
    coalesce(m017_p.contact_txt, '-1') as phone,
    coalesce(m017_e.contact_txt, '-1') as email
from
    dev_demo_il.m006_party as m006
    inner join
      dev_demo_il.m008_indiv m008
      on m006.party_id = m008.party_id
    inner join
      (select party_id, rel_cd from dev_demo_il.m014_order_party_rltd group by 1,2) m014 
      on m006.party_id = m014.party_id
      and m014.rel_cd = 5 --Order - Employee
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

;
CALL dev_demo_ml.sp_deployment_objects('w_dim_employee', 'dev_demo_al');
END TRANSACTION;

