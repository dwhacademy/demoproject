BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_dim_customer()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_al.customer;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_dim_customer', 'dim_customer','delete', V_AFF_CNT);
insert into
  dev_demo_al.dim_customer (
    customer_id,
    customer_nm,
    phone,
    email,
    city,
    state
  )
select
  w_dim.customer_id,
  w_dim.customer_nm,
  w_dim.phone,
  w_dim.email,
  w_dim.city,
  w_dim.state
from
  dev_demo_al.w_dim_customer as w_dim
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_dim_customer', 'dim_customer','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_dim_customer', 'dev_demo_al');
END TRANSACTION;


