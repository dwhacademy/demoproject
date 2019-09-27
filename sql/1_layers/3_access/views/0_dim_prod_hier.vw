BEGIN TRANSACTION;
create or replace view dev_demo_al.dim_prod_hier as
	
select
	    hier.prod_id as prod_id
	    , m004.prod_nm as prod_nm
	    , m004.price as price
	    , m004.model_year as model_year
	    , MAX(CASE WHEN hier.lvl = 1 THEN hier.hier_item_nm END)    AS lvl1_nm
	    , MAX(CASE WHEN hier.lvl = 2 THEN hier.hier_item_nm END)    AS lvl2_nm
	    , MAX(CASE WHEN hier.lvl = 3 THEN hier.hier_item_nm END)    AS lvl3_nm
	    , MAX(CASE WHEN hier.lvl = 4 THEN hier.hier_item_nm END)    AS lvl4_nm
	    , MAX(CASE WHEN hier.lvl = 5 THEN hier.hier_item_nm END)    AS lvl5_nm
	    , MAX(CASE WHEN hier.lvl = 6 THEN hier.hier_item_nm END)    AS lvl6_nm
	    , MAX(CASE WHEN hier.lvl = 7 THEN hier.hier_item_nm END)    AS lvl7_nm
	    , MAX(CASE WHEN hier.lvl = 8 THEN hier.hier_item_nm END)    AS lvl8_nm
	    , MAX(CASE WHEN hier.lvl = 9 THEN hier.hier_item_nm END)    AS lvl9_nm
	from
	  dev_demo_il.w_hier hier
	  inner join
	    dev_demo_il.m002_hier m002
	    on hier.hier_cd = m002.hier_cd
	    and m002.hier_nm = 'Product_Group'
	  inner join
	    dev_demo_il.m004_prod m004
	    on hier.prod_id = m004.prod_id

	group by
	    hier.prod_id, m004.prod_nm, m004.price, m004.model_year
;

CALL dev_demo_ml.sp_deployment_objects('dim_prod_hier', 'dev_demo_al');
END TRANSACTION;

