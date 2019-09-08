CALL dev_demo_ml.sp_load_start();
CALL dev_demo_il.sp_load_il();
CALL dev_demo_ml.sp_load_end();
select * from dev_demo_ml.log order by log_ts desc;
