-- Base Tables
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  account_number VARCHAR(50) NOT NULL,
  balance DECIMAL(12,2) DEFAULT 0.00,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  account_id INT REFERENCES accounts(id),
  amount DECIMAL(12,2) NOT NULL,
  transaction_type VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ DEFAULT NULL
);

-- Move 05: Partial Indexes for Active Query Performance Optimization
CREATE INDEX IF NOT EXISTS idx_users_active ON users(id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_accounts_active ON accounts(id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_transactions_active ON transactions(id) WHERE deleted_at IS NULL;