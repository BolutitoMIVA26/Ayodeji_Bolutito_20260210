-- Show related customer, sales_order, order_line, yarn_product records (up to 20).
SELECT t0."customer_id" AS "customer_customer_id",
       t0."email" AS "customer_email",
       t1."order_id" AS "sales_order_order_id",
       t1."order_number" AS "sales_order_order_number",
       t2."order_line_id" AS "order_line_order_line_id",
       t2."quantity" AS "order_line_quantity",
       t3."product_id" AS "yarn_product_product_id",
       t3."sku" AS "yarn_product_sku"
FROM portfolio."customer" t0
JOIN portfolio."sales_order" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."order_line" t2 ON t2."order_id" = t1."order_id"
JOIN portfolio."yarn_product" t3 ON t2."product_id" = t3."product_id"
ORDER BY t0."customer_id", t1."order_id", t2."order_line_id", t3."product_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."customer_id" AS "customer_customer_id",
       t0."email" AS "customer_email",
       t1."order_id" AS "sales_order_order_id",
       t1."order_number" AS "sales_order_order_number",
       t2."order_line_id" AS "order_line_order_line_id",
       t2."quantity" AS "order_line_quantity",
       t3."product_id" AS "yarn_product_product_id",
       t3."sku" AS "yarn_product_sku"
FROM portfolio."customer" t0
JOIN portfolio."sales_order" t1 ON t1."customer_id" = t0."customer_id"
JOIN portfolio."order_line" t2 ON t2."order_id" = t1."order_id"
JOIN portfolio."yarn_product" t3 ON t2."product_id" = t3."product_id"
ORDER BY t0."customer_id", t1."order_id", t2."order_line_id", t3."product_id"
LIMIT 20;

-- Find sales_order records where ordered_at matches "2026-05-14T10:30:00Z" (up to 20).
SELECT * FROM portfolio."sales_order"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-05-14T10:30:00Z'
ORDER BY "order_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."sales_order"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-05-14T10:30:00Z'
ORDER BY "order_id"
LIMIT 20;

-- Count order_line records for each order_id (up to 20 groups).
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_line"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_line"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
