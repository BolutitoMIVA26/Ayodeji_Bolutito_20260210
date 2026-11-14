# Yarn Store Management System — SQL queries

## 1. Show related customer, sales_order, order_line, yarn_product records (up to 20).

```sql
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
```

| customer_customer_id | customer_email | sales_order_order_id | sales_order_order_number | order_line_order_line_id | order_line_quantity | yarn_product_product_id | yarn_product_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 101 | mira@example.test | 301 | ORD-2026-001 | 401 | 2 | 201 | YRN-001 |

## 2. Find sales_order records where ordered_at matches "2026-05-14T10:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."sales_order"
WHERE "ordered_at" IS NOT DISTINCT FROM '2026-05-14T10:30:00Z'
ORDER BY "order_id"
LIMIT 20;
```

| order_id | customer_id | order_number | ordered_at | status |
| --- | --- | --- | --- | --- |
| 301 | 101 | ORD-2026-001 | 2026-05-14T10:30:00+00:00 | placed |

## 3. Count order_line records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."order_line"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 301 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.24 | 1.24, 0.97, 1.304 | Sort → Seq Scan | 112 |
| After index | 0.185 | 0.184, 0.185, 0.19 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.24 ms to 0.185 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.217..1.218 rows=20 loops=1)
  Seq Scan on sales_order (actual time=0.015..1.183 rows=20 loops=1)
Planning Time: 0.383 ms
Execution Time: 1.24 ms
```

### Before index, run 2

```text
Sort (actual time=0.946..0.948 rows=20 loops=1)
  Seq Scan on sales_order (actual time=0.016..0.914 rows=20 loops=1)
Planning Time: 0.374 ms
Execution Time: 0.97 ms
```

### Before index, run 3

```text
Sort (actual time=1.279..1.281 rows=20 loops=1)
  Seq Scan on sales_order (actual time=0.017..1.243 rows=20 loops=1)
Planning Time: 0.382 ms
Execution Time: 1.304 ms
```

### After index, run 1

```text
Sort (actual time=0.126..0.127 rows=20 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.028..0.09 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.581 ms
Execution Time: 0.184 ms
```

### After index, run 2

```text
Sort (actual time=0.128..0.129 rows=20 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.028..0.092 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.554 ms
Execution Time: 0.185 ms
```

### After index, run 3

```text
Sort (actual time=0.129..0.131 rows=20 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.029..0.092 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.593 ms
Execution Time: 0.19 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ayodeji_Bolutito_20260210_P2_Queries.sql, then Ayodeji_Bolutito_20260210_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ayodeji_Bolutito_20260210_P2_QueryResults.png) · [Index comparison](screenshots/Ayodeji_Bolutito_20260210_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

