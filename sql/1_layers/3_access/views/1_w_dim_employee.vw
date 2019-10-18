BEGIN TRANSACTION;
create or replace view dev_demo_al.w_dim_employee as

select
    a006.party_id as employee_id,
    a008.first_nm||' '||a008.last_nm as employee_nm,
    coalesce(a017_p.contact_txt, '-1') as phone,
    coalesce(a017_e.contact_txt, '-1') as email
from
    dev_demo_il.a006_party as a006
    inner join
      dev_demo_il.a008_indiv a008
      on a006.party_id = a008.party_id
    inner join
      (select party_id, rel_cd from dev_demo_il.a014_order_party_rltd group by 1,2) a014 
      on a006.party_id = a014.party_id
      and a014.rel_cd = 5 --Order - Employee
    left join
        (select party_id, contact_txt 
        from 
            dev_demo_il.a017_party_contact_rltd a017
            inner join
                dev_demo_il.a016_contact a016
                on a017.contact_id = a016.contact_id
                and a016.contact_type = 'Phone'
              where  
                a017.rel_cd = 2 --Party - Contact
        ) a017_p
          on a006.party_id = a017_p.party_id
    left join
        (select party_id, contact_txt 
        from 
            dev_demo_il.a017_party_contact_rltd a017
            inner join
                dev_demo_il.a016_contact a016
                on a017.contact_id = a016.contact_id
                and a016.contact_type = 'Email'
            where  
              a017.rel_cd = 2 --Party - Contact
        ) a017_e
          on a006.party_id = a017_e.party_id

;
CALL dev_demo_ml.sp_deployment_objects('w_dim_employee', 'dev_demo_al');
END TRANSACTION;

