BEGIN TRANSACTION;
create or replace view dev_demo_il.w_015_address as

select
    k012.loc_id as loc_id,
    'Address' as loc_subtype,
    a.street as street,
    a.city as city,
    a.state as state,
    cast(a.zip_code as varchar(255)) as zip_cd,
    'Address' as loc_src_pfx,
    a.street||'#'||a.zip_code as loc_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.branches as a
    left join
      dev_demo_il.k012_loc_key k012
      on cast(a.street||'#'||a.zip_code as varchar(255)) = k012.loc_src_key
      and k012.loc_src_pfx = 'Address'

group by 1,2,3,4,5,6,7,8,9

union

select
    k012.loc_id as loc_id,
    'Address' as loc_subtype,
    a.street as street,
    a.city as city,
    a.state as state,
    cast(a.zip_code as varchar(255)) as zip_cd,
    'Address' as loc_src_pfx,
    a.street||'#'||a.zip_code as loc_src_key,
    1 as src_syst_id --source code for master data
from
    dev_demo_sl.customers as a
    left join
      dev_demo_il.k012_loc_key k012
      on cast(a.street||'#'||a.zip_code as varchar(255)) = k012.loc_src_key
      and k012.loc_src_pfx = 'Address'

group by 1,2,3,4,5,6,7,8,9

;
CALL dev_demo_ml.sp_deployment_objects('w_015_address', 'dev_demo_il');
END TRANSACTION;

