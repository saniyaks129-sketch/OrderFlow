# Production Database Debugging Report — OrderFlow API

## Bug 1: Orphaned Orders / Missing Customer Foreign Key

### 1. Symptom & Reproduction Query
Orders exist in the database with `customer_id` values that do not exist in the `customers` table.

```sql
SELECT o.id AS order_id, o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id
WHERE c.id IS NULL;