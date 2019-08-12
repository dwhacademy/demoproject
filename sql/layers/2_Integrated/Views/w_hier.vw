CREATE OR REPLACE RECURSIVE VIEW demo_il.w_hier(hier_item_id, hier_item_nm, lvl, hier_cd, parent_hier_item_id, mn_id) AS (
    SELECT
        m001.hier_item_id, m001.hier_item_nm, m001.lvl, m001.hier_cd, m003_c.parent_hier_item_id, m001.hier_item_id AS mn_id
    FROM
        demo_il.m001_hier_item m001
        INNER JOIN demo_il.m003_hier_item_rltd m003_c
                ON m001.hier_item_id    = m003_c.child_hier_item_id
        LEFT JOIN demo_il.m003_hier_item_rltd m003_p
                ON m001.hier_item_id    = m003_p.parent_hier_item_id

    WHERE
        m003_p.parent_hier_item_id IS NULL
    UNION ALL
    SELECT
        m001.hier_item_id, m001.hier_item_nm, m001.lvl, m001.hier_cd, m003_c.parent_hier_item_id, w.mn_id
    FROM
        w_hier w
        INNER JOIN demo_il.m001_hier_item m001
                ON w.parent_hier_item_id = m001.hier_item_id
        INNER JOIN demo_il.m003_hier_item_rltd m003_c
                ON w.hier_item_id        = m003_c.child_hier_item_id
)
;
