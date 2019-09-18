BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_il.sp_md_k006_party_key()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
insert into
  dev_demo_il.k006_party_key (
    party_id,
    party_src_pfx,
    party_src_key,
    src_syst_id
  )
-- SK generation for Individuals
select
  row_number() over(order by w_008.party_src_key) + k006.last_sk as party_id,
  w_008.party_src_pfx,
  w_008.party_src_key,
  w_008.src_syst_id --source code for master data
from
  dev_demo_il.w_008_indiv w_008
cross join
  (select coalesce(max(party_id),1000000) as last_sk from dev_demo_il.k006_party_key) k006
where
  w_008.party_id is null
group by w_008.party_src_pfx, w_008.party_src_key,  w_008.src_syst_id, k006.last_sk

union
-- SK generation for Organizations
select
  row_number() over(order by w_009.party_src_key) + k006.last_sk as party_id,
  w_009.party_src_pfx,
  w_009.party_src_key,
  w_009.src_syst_id --source code for master data
from
  dev_demo_il.w_009_org w_009
cross join
  (select coalesce(max(party_id),1000000) as last_sk from dev_demo_il.k006_party_key) k006
where
  w_009.party_id is null
group by w_009.party_src_pfx, w_009.party_src_key,  w_009.src_syst_id, k006.last_sk
;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_il', 'sp_md_k006_party_key', 'k006_party_key','insert', V_AFF_CNT);
END
$$;
CALL dev_demo_ml.sp_deployment_objects('sp_md_k006_party_key', 'dev_demo_il');
END TRANSACTION;

