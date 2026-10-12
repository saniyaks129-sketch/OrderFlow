-- Base Tables Definition
CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  sku VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  customer_id INT,
  total_amount DECIMAL(10,2) DEFAULT 0.00,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id),
  quantity INT,
  price DECIMAL(10,2) NOT NULL
);

-- =================================================================
-- PRODUCTION BUG FIXES (Schema-Level Constraints)
-- =================================================================

-- Fix 1: Add Foreign Key Constraint on Orders (Prevents Orphaned Records)
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(id)
ON DELETE RESTRICT;

-- Fix 2: Add NOT NULL and Positive CHECK Constraint on Order Items Quantity
ALTER TABLE order_items
ALTER COLUMN quantity SET NOT NULL;

ALTER TABLE order_items
ADD CONSTRAINT check_positive_quantity CHECK (quantity > 0);

-- Fix 3: Add UNIQUE Constraint on Product SKUs (Prevents Duplicate Inventory Keys)
ALTER TABLE products
ADD CONSTRAINT unique_product_sku UNIQUE (sku);