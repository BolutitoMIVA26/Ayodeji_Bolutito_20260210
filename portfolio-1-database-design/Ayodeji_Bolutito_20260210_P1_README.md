# Portfolio 1 — Database Design and Modelling

I organised the data into customer, yarn_product, sales_order, order_line. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customer | 1 |
| yarn_product | 1 |
| sales_order | 1 |
| order_line | 1 |

The 13 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Ayodeji_Bolutito_20260210_P1_Design.md)
- [ER diagram](Ayodeji_Bolutito_20260210_P1_ERDiagram.md)
- [Normalisation](Ayodeji_Bolutito_20260210_P1_Normalisation.md)
- [Schema](Ayodeji_Bolutito_20260210_P1_Schema.sql)
- [Sample data](Ayodeji_Bolutito_20260210_P1_SampleData.sql)
- [Constraint tests](Ayodeji_Bolutito_20260210_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Ayodeji_Bolutito_20260210_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

