# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection yarn_order_events for order_placed and line_added events. These are fictional event examples based on order_line, sales_order, customer, yarn_product.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related sales_order, customer, yarn_product details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_line",
        "key": {
            "order_line_id": 401
        },
        "snapshot": {
            "order_line_id": 401,
            "order_id": 301,
            "product_id": 201,
            "quantity": 2,
            "unit_price": 18.5
        }
    },
    "embedded": {
        "sales_order": [
            {
                "key": {
                    "order_id": 301
                },
                "snapshot": {
                    "order_id": 301,
                    "customer_id": 101,
                    "order_number": "ORD-2026-001",
                    "ordered_at": "2026-05-14T10:30:00Z",
                    "status": "placed"
                },
                "via": [
                    "order_line.order_id → sales_order"
                ]
            }
        ],
        "customer": [
            {
                "key": {
                    "customer_id": 101
                },
                "snapshot": {
                    "customer_id": 101,
                    "email": "mira@example.test",
                    "display_name": "Mira Chen",
                    "joined_on": "2026-03-10"
                },
                "via": [
                    "order_line.order_id → sales_order.customer_id → customer"
                ]
            }
        ],
        "yarn_product": [
            {
                "key": {
                    "product_id": 201
                },
                "snapshot": {
                    "product_id": 201,
                    "sku": "YRN-001",
                    "yarn_name": "Meadow Merino",
                    "fiber_content": "100% merino wool",
                    "price": 18.5,
                    "active": true
                },
                "via": [
                    "order_line.product_id → yarn_product"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("yarn_order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("yarn_order_events").find({"source.key.order_line_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "line_added",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("yarn_order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "line_added",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_line_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("yarn_order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| line_added | 1 |
| order_placed | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Ayodeji_Bolutito_20260210_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Ayodeji_Bolutito_20260210_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

