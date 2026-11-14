# Yarn Store Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| order_id | order_line records (list) |
| --- | --- |
| 301 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| order_line.order_line_id | order_line.order_id | order_line.product_id | sales_order.order_id | sales_order.customer_id | sales_order.order_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 301 | 101 | ORD-2026-001 | 101 | mira@example.test |

Key: order_line_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## order_line_example

| order_line.order_line_id | order_line.order_id | order_line.product_id | sales_order.order_id | sales_order.customer_id | sales_order.order_number | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 301 | 101 | ORD-2026-001 | 101 | mira@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | display_name | joined_on |
| --- | --- | --- | --- |
| 101 | mira@example.test | Mira Chen | 2026-03-10 |

## yarn_product

| product_id | sku | yarn_name | fiber_content | price | active |
| --- | --- | --- | --- | --- | --- |
| 201 | YRN-001 | Meadow Merino | 100% merino wool | 18.5 | true |

## sales_order

| order_id | customer_id | order_number | ordered_at | status |
| --- | --- | --- | --- | --- |
| 301 | 101 | ORD-2026-001 | 2026-05-14T10:30:00+00:00 | placed |

## order_line

| order_line_id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 2 | 18.5 |

## Dependencies

- customer: (customer_id) → email, display_name, joined_on
- yarn_product: (product_id) → sku, yarn_name, fiber_content, price, active
- sales_order: (order_id) → customer_id, order_number, ordered_at, status
- order_line: (order_line_id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
