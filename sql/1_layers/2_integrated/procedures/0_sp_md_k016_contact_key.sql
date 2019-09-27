BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k016_contact_key()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
insert into
  dev_demo_il.k016_contact_key (
    contact_id,
    contact_src_pfx,
    contact_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_016.contact_src_key) + k016.last_sk as contact_id,
  w_016.contact_src_pfx,
  w_016.contact_src_key,
  w_016.src_syst_id --source code for master data
from
  dev_demo_il.w_016_contact w_016
cross join
  (select coalesce(max(contact_id),1000000) as last_sk from dev_demo_il.k016_contact_key) k016
where
  w_016.contact_id is null
group by w_016.contact_src_pfx, w_016.contact_src_key,  w_016.src_syst_id, k016.last_sk
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_k016_contact_key', 'k016_contact_key','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k016_contact_key', 'dev_demo_il');
END TRANSACTION;

