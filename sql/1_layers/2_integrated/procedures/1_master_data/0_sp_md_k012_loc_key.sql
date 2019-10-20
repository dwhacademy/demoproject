BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k012_loc_key()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
insert into
  dev_demo_il.k012_loc_key (
    loc_id,
    loc_src_pfx,
    loc_src_key,
    src_syst_id
  )
select
  row_number() over(order by w_015.loc_src_key) + k012.last_sk as loc_id,
  w_015.loc_src_pfx,
  w_015.loc_src_key,
  w_015.src_syst_id --source code for master data
from
  dev_demo_il.w_015_address w_015
cross join
  (select coalesce(max(loc_id),1000000) as last_sk from dev_demo_il.k012_loc_key) k012
where
  w_015.loc_id is null
group by w_015.loc_src_pfx, w_015.loc_src_key,  w_015.src_syst_id, k012.last_sk
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_k012_loc_key', 'k012_loc_key','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k012_loc_key', 'dev_demo_il');
END TRANSACTION;

