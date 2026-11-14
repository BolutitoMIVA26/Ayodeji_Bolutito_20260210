# Yarn Store Management System — database design

My case study records customer, yarn_product, sales_order, order_line.

## Users

- Shop staff maintaining customer and product records
- Shop staff reviewing orders and sales

## Main operations

- Add customers and yarn products
- Record orders and their line items
- Review orders by date and summarize sales by product

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person who places yarn orders. |
| yarn_product | A yarn product offered by the shop. |
| sales_order | An order placed by one customer. |
| order_line | A yarn product and quantity included in an order, with its sale-time unit price. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| joined_on | DATE |  | Yes |
- Unique key: (email).

## yarn_product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| yarn_name | TEXT |  | Yes |
| fiber_content | TEXT |  | Yes |
| price | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## sales_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| order_number | TEXT | Unique | Yes |
| ordered_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customer.customer_id
- Unique key: (order_number).

## order_line

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_line_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → sales_order.order_id
- product_id → yarn_product.product_id

## Relationships and business rules

- Each customer email address must be unique.
- Each yarn product SKU must be unique.
- A product's listed price must be greater than zero.
- Each sales order number must be unique, including during concurrent order creation.
- Every sales order must reference an existing customer through customer_id.
- Every order line must have a quantity greater than zero.
- Every order line must reference an existing sales order through order_id.
- Every order line must reference an existing yarn product through product_id.

## Assumptions

- Use one currency and store the sale-time unit price on each order line.
- For normalization, start with order_line: its key determines its order, product, quantity, and sale-time unit price. Store order details in sales_order, customer details in customer, and product details in yarn_product rather than repeating parent attributes on each line.
- For a separate benchmark exercise, generate 20000 synthetic sales_order rows and compare the same ordered_at date-range filter before and after a B-tree index; record the query plan and repeated execution measurements.

