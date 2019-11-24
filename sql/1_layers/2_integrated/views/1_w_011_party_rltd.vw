BEGIN TRANSACTION;
create or replace view dev_demo_il.w_011_party_rltd as

select
    k006_mgr.party_id as parent_party_id,
    k006_emp.party_id as child_party_id,
    v010.rel_cd as rel_cd
from
    dev_demo_sl.employees as a
    inner join
      dev_demo_sl.employees as b
      on a.manager_id = b.employee_id
    inner join
      dev_demo_il.k006_party_key k006_emp
      on a.first_name||'#'||a.last_name = k006_emp.party_src_key
      and k006_emp.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k006_party_key k006_mgr
      on b.first_name||'#'||b.last_name = k006_mgr.party_src_key
      and k006_mgr.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.v010_rel_type v010
      on v010.rel_nm = 'Manager - Employee'

group by 1,2,3

union

select
    k006_br.party_id as parent_party_id,
    k006_emp.party_id as child_party_id,
    v010.rel_cd as rel_cd
from
    dev_demo_sl.employees as a
    inner join
      dev_demo_sl.branches as b
      on a.branch_id = b.branch_id
    inner join
      dev_demo_il.k006_party_key k006_emp
      on a.first_name||'#'||a.last_name = k006_emp.party_src_key
      and k006_emp.party_src_pfx = 'Individual'
    inner join
      dev_demo_il.k006_party_key k006_br
      on b.branch_name = k006_br.party_src_key
      and k006_br.party_src_pfx = 'Organization'
    inner join
      dev_demo_il.v010_rel_type v010
      on v010.rel_nm = 'Branch - Employee'

group by 1,2,3
;

CALL dev_demo_ml.sp_deployment_objects('w_011_party_rltd', 'dev_demo_il');
END TRANSACTION;

