BEGIN TRANSACTION;
CREATE OR REPLACE RECURSIVE VIEW dev_demo_il.w_hier(hier_item_id, hier_item_nm, lvl, hier_cd, parent_hier_item_id, prod_id) AS (
  SELECT
    m001.hier_item_id, m001.hier_item_nm, m001.lvl, m001.hier_cd, m003_c.parent_hier_item_id, m005.prod_id AS prod_id
  FROM
    dev_demo_il.m001_hier_item m001
    INNER JOIN
        dev_demo_il.m003_hier_item_rltd m003_c
        ON m001.hier_item_id = m003_c.child_hier_item_id
    INNER JOIN
        dev_demo_il.m005_hier_item_prod_rltd m005
        ON m001.hier_item_id = m005.hier_item_id
  UNION ALL
  SELECT
    m001.hier_item_id, m001.hier_item_nm, m001.lvl, m001.hier_cd, m003_c.parent_hier_item_id, w.prod_id
  FROM
    w_hier w
    INNER JOIN
        dev_demo_il.m001_hier_item m001
        ON w.parent_hier_item_id = m001.hier_item_id
    INNER JOIN
        dev_demo_il.m003_hier_item_rltd m003_c
        ON w.hier_item_id = m003_c.child_hier_item_id
);
CALL dev_demo_ml.sp_deployment_objects('w_hier', 'dev_demo_il');
END TRANSACTION;

