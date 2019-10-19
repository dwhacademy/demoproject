BEGIN TRANSACTION;
CREATE OR REPLACE RECURSIVE VIEW dev_demo_il.w_hier(hier_item_id, hier_item_nm, lvl, hier_cd, parent_hier_item_id, prod_id) AS (
  SELECT
    v001.hier_item_id, v001.hier_item_nm, v001.lvl, v001.hier_cd, v003_c.parent_hier_item_id, v005.prod_id AS prod_id
  FROM
    dev_demo_il.v001_hier_item v001
    INNER JOIN
        dev_demo_il.v003_hier_item_rltd v003_c
        ON v001.hier_item_id = v003_c.child_hier_item_id
    INNER JOIN
        dev_demo_il.v005_hier_item_prod_rltd v005
        ON v001.hier_item_id = v005.hier_item_id
  UNION ALL
  SELECT
    v001.hier_item_id, v001.hier_item_nm, v001.lvl, v001.hier_cd, v003_c.parent_hier_item_id, w.prod_id
  FROM
    w_hier w
    INNER JOIN
        dev_demo_il.v001_hier_item v001
        ON w.parent_hier_item_id = v001.hier_item_id
    INNER JOIN
        dev_demo_il.v003_hier_item_rltd v003_c
        ON w.hier_item_id = v003_c.child_hier_item_id
);
CALL dev_demo_ml.sp_deployment_objects('w_hier', 'dev_demo_il');
END TRANSACTION;

