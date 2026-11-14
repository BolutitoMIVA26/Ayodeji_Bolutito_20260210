-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer duplicate pk. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "joined_on")
VALUES (101, 'customer-pk-test@example.test', 'Customer PK Test', '2026-06-01');

-- 2. customer duplicate email. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "joined_on")
VALUES (1001, 'mira@example.test', 'Customer Email Test', '2026-06-02');

-- 3. customer missing display name. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "display_name", "joined_on")
VALUES (1002, 'customer-null-test@example.test', NULL, '2026-06-03');

-- 4. product duplicate pk. Expected: pk_yarn_product, SQLSTATE 23505.
INSERT INTO portfolio."yarn_product" ("product_id", "sku", "yarn_name", "fiber_content", "price", "active")
VALUES (201, 'YRN-PK-TEST', 'Product PK Test', '100% cotton', 12, TRUE);

-- 5. product duplicate sku. Expected: uq_yarn_product_0, SQLSTATE 23505.
INSERT INTO portfolio."yarn_product" ("product_id", "sku", "yarn_name", "fiber_content", "price", "active")
VALUES (1003, 'YRN-001', 'Product SKU Test', '100% cotton', 12, TRUE);

-- 6. product nonpositive price. Expected: product_price_positive, SQLSTATE 23514.
INSERT INTO portfolio."yarn_product" ("product_id", "sku", "yarn_name", "fiber_content", "price", "active")
VALUES (1004, 'YRN-CHECK-TEST', 'Product Price Test', '100% cotton', 0, TRUE);

-- 7. order duplicate pk. Expected: pk_sales_order, SQLSTATE 23505.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "order_number", "ordered_at", "status")
VALUES (301, 101, 'ORD-PK-TEST', '2026-06-04T10:00:00Z', 'placed');

-- 8. order duplicate number. Expected: uq_sales_order_0, SQLSTATE 23505.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "order_number", "ordered_at", "status")
VALUES (1005, 101, 'ORD-2026-001', '2026-06-05T10:00:00Z', 'placed');

-- 9. order missing customer. Expected: fk_sales_order_0, SQLSTATE 23503.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "order_number", "ordered_at", "status")
VALUES (1006, 99901, 'ORD-FK-TEST', '2026-06-06T10:00:00Z', 'placed');

-- 10. line duplicate pk. Expected: pk_order_line, SQLSTATE 23505.
INSERT INTO portfolio."order_line" ("order_line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (401, 301, 201, 1, 18.5);

-- 11. line missing order. Expected: fk_order_line_0, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("order_line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1007, 99902, 201, 1, 18.5);

-- 12. line missing product. Expected: fk_order_line_1, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("order_line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1008, 301, 99903, 1, 18.5);

-- 13. line nonpositive quantity. Expected: line_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_line" ("order_line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (1009, 301, 201, 0, 18.5);
