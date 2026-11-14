# Yarn Store Management System — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text email UK
        text display_name
        date joined_on
    }
    yarn_product {
        bigint product_id PK
        text sku UK
        text yarn_name
        text fiber_content
        numeric price
        boolean active
    }
    sales_order {
        bigint order_id PK
        bigint customer_id FK
        text order_number UK
        timestamptz ordered_at
        text status
    }
    order_line {
        bigint order_line_id PK
        bigint order_id FK
        bigint product_id FK
        integer quantity
        numeric unit_price
    }
    customer ||--o{ sales_order : "customer_id"
    sales_order ||--o{ order_line : "order_id"
    yarn_product ||--o{ order_line : "product_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ayodeji_Bolutito_20260210_ERDiagram.png)
