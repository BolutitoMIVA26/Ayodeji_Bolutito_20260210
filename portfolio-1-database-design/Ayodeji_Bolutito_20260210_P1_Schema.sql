-- Yarn Store Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "email" text NOT NULL,
  "display_name" text NOT NULL,
  "joined_on" date NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."yarn_product" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "yarn_name" text NOT NULL,
  "fiber_content" text NOT NULL,
  "price" numeric(18,2) NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_yarn_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_yarn_product_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."sales_order" (
  "order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "order_number" text NOT NULL,
  "ordered_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_sales_order" PRIMARY KEY ("order_id"),
  CONSTRAINT "uq_sales_order_0" UNIQUE ("order_number")
);
CREATE TABLE portfolio."order_line" (
  "order_line_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_line" PRIMARY KEY ("order_line_id")
);
ALTER TABLE portfolio."sales_order" ADD CONSTRAINT "fk_sales_order_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "fk_order_line_0" FOREIGN KEY ("order_id") REFERENCES portfolio."sales_order" ("order_id");
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "fk_order_line_1" FOREIGN KEY ("product_id") REFERENCES portfolio."yarn_product" ("product_id");
ALTER TABLE portfolio."yarn_product" ADD CONSTRAINT "product_price_positive" CHECK ("price" > 0);
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "line_quantity_positive" CHECK ("quantity" > 0);
COMMIT;
