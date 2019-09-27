BEGIN TRANSACTION;
CREATE OR REPLACE PROCEDURE dev_demo_al.sp_dim_employee()
LANGUAGE plpgsql
AS $$
DECLARE V_LOAD_ID INTEGER;
DECLARE V_AFF_CNT INTEGER;
BEGIN
SELECT MAX(load_id) into V_LOAD_ID  FROM dev_demo_ml.load; 
delete from dev_demo_al.dim_employee;

/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_dim_employee', 'dim_employee','delete', V_AFF_CNT);
insert into
  dev_demo_al.dim_employee (
    employee_id,
    employee_nm,
    phone,
    email
  )
select
  w_dim.employee_id,
  w_dim.employee_nm,
  w_dim.phone,
  w_dim.email
from
  dev_demo_al.w_dim_employee as w_dim
;
  
/********************************************
 * LOGGING ACTIVITY
********************************************/
GET DIAGNOSTICS V_AFF_CNT = ROW_COUNT;
INSERT INTO dev_demo_ml.log VALUES(V_LOAD_ID, CURRENT_TIMESTAMP, 'dev_demo_al', 'sp_dim_employee', 'dim_employee','insert', V_AFF_CNT);
END
$$;

CALL dev_demo_ml.sp_deployment_objects('sp_dim_employee', 'dev_demo_al');
END TRANSACTION;


