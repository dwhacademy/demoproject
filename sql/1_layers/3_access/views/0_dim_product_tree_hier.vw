CREATE OR REPlACE VIEW dev_demo_al.dim_product_tree_hier (hier_nm, prod_id, prod_nm, lvl1_id, lvl1_nm , lvl2_id, lvl2_nm , lvl3_id, lvl3_nm , lvl4_id, lvl4_nm , lvl5_id, lvl5_nm , lvl6_id, lvl6_nm , lvl7_id, lvl7_nm , lvl8_id, lvl8_nm, lvl9_id, lvl9_nm ) AS
	SElECT
	      B.hier_nm
	    , A.prod_id
	    , C.prod_nm
	    , MAX(CASE WHEN A.lvl = 1 THEN A.hier_item_id END)    AS lvl1_id
	    , MAX(CASE WHEN A.lvl = 1 THEN A.hier_item_nm END)    AS lvl1_nm
	    , MAX(CASE WHEN A.lvl = 2 THEN A.hier_item_id END)    AS lvl2_id
	    , MAX(CASE WHEN A.lvl = 2 THEN A.hier_item_nm END)    AS lvl2_nm
	    , MAX(CASE WHEN A.lvl = 3 THEN A.hier_item_id END)    AS lvl3_id
	    , MAX(CASE WHEN A.lvl = 3 THEN A.hier_item_nm END)    AS lvl3_nm
	    , MAX(CASE WHEN A.lvl = 4 THEN A.hier_item_id END)    AS lvl4_id
	    , MAX(CASE WHEN A.lvl = 4 THEN A.hier_item_nm END)    AS lvl4_nm
	    , MAX(CASE WHEN A.lvl = 5 THEN A.hier_item_id END)    AS lvl5_id
	    , MAX(CASE WHEN A.lvl = 5 THEN A.hier_item_nm END)    AS lvl5_nm
	    , MAX(CASE WHEN A.lvl = 6 THEN A.hier_item_id END)    AS lvl6_id
	    , MAX(CASE WHEN A.lvl = 6 THEN A.hier_item_nm END)    AS lvl6_nm
	    , MAX(CASE WHEN A.lvl = 7 THEN A.hier_item_id END)    AS lvl7_id
	    , MAX(CASE WHEN A.lvl = 7 THEN A.hier_item_nm END)    AS lvl7_nm
	    , MAX(CASE WHEN A.lvl = 8 THEN A.hier_item_id END)    AS lvl8_id
	    , MAX(CASE WHEN A.lvl = 8 THEN A.hier_item_nm END)    AS lvl8_nm
	    , MAX(CASE WHEN A.lvl = 9 THEN A.hier_item_id END)    AS lvl9_id
	    , MAX(CASE WHEN A.lvl = 9 THEN A.hier_item_nm END)    AS lvl9_nm
	FROM
	  dev_demo_il.w_hier A
	  INNER JOIN
	    dev_demo_il.m002_hier B
	    ON A.hier_cd = B.hier_cd
	  INNER JOIN
	    dev_demo_il.m004_prod C
	    ON A.prod_id = C.prod_id

	GROUP BY
	    B.hier_nm, A.prod_id, C.prod_nm
;