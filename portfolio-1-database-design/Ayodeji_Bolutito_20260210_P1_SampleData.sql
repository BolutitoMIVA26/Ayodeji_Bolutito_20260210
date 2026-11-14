-- Fictional sample records for Yarn Store Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "joined_on") VALUES (101, 'mira@example.test', 'Mira Chen', '2026-03-10');
INSERT INTO portfolio."yarn_product" ("product_id", "sku", "yarn_name", "fiber_content", "price", "active") VALUES (201, 'YRN-001', 'Meadow Merino', '100% merino wool', 18.5, TRUE);
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "order_number", "ordered_at", "status") VALUES (301, 101, 'ORD-2026-001', '2026-05-14T10:30:00Z', 'placed');
INSERT INTO portfolio."order_line" ("order_line_id", "order_id", "product_id", "quantity", "unit_price") VALUES (401, 301, 201, 2, 18.5);
COMMIT;
