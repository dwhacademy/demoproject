BEGIN TRANSACTION;
create or replace view dev_demo_al.w_dim_customer as

select
    a006.party_id as customer_id,
    a008.first_nm||' '||a008.last_nm as customer_nm,
    coalesce(a017_p.contact_txt, '-1') as phone,
    coalesce(a017_e.contact_txt, '-1') as email,
    coalesce(a015.city, '-1') as city,
    coalesce(a015.state, '-1') as state
from
    dev_demo_il.a006_party as a006
    inner join
      dev_demo_il.a008_indiv a008
      on a006.party_id = a008.party_id
    inner join
      (select party_id, rel_cd from dev_demo_il.a014_order_party_rltd group by 1,2) a014 
      on a006.party_id = a014.party_id
      and a014.rel_cd = 6 --Order - Customer
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
    left join
      dev_demo_il.a007_party_loc_rltd a007
      on a006.party_id = a007.party_id
      and a007.rel_cd = 1 --Party - Address
    left join
      dev_demo_il.a012_loc a012
      on a007.loc_id = a012.loc_id
    left join
      dev_demo_il.a015_address a015
      on a012.loc_id = a015.loc_id

;
CALL dev_demo_ml.sp_deployment_objects('w_dim_customer', 'dev_demo_al');
END TRANSACTION;

