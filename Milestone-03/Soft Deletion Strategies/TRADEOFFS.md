# Soft Deletion Strategy & Trade-Off Analysis

## 1. When Soft Delete is the Right Call (LedgerApp Context)
- **Financial Transaction Auditing:** Tax and banking regulations (SOX/FinCEN) mandate that financial ledgers retain transaction histories for 7+ years. Soft deletion preserves an immutable audit trail while keeping deleted items hidden from active user dashboards.
- **Accidental Account Recovery:** Allows instant customer account or ledger restoration without permanent data loss (`UPDATE accounts SET deleted_at = NULL`).

## 2. When Hard Delete is Still Appropriate
- **GDPR "Right to Erasure":** User personally identifiable information (PII) must be permanently deleted from database storage upon request after mandatory legal retention windows expire.
- **Ephemeral Session Data:** Authentication tokens and one-time passcodes (OTPs) must be hard-deleted on logout/expiration to prevent security vulnerabilities and database storage overhead.

## 3. Performance & Partial Indexes
- **Table Bloat:** Soft deletes accumulate rows over time. Assuming LedgerApp logs 100,000 transactions/month with a 5% deletion rate, ~60,000 deleted rows accumulate annually.
- **Partial Index Solution:** Running `CREATE INDEX idx_transactions_active ON transactions(id) WHERE deleted_at IS NULL;` ensures PostgreSQL only indexes active rows, keeping index size minimal and lookup speeds under <1ms.

## 4. Regulatory Compliance Scenario
- **Scenario:** A legal auditor requests transaction history for user ID 4821.
- **Query:** Running `SELECT * FROM transactions WHERE user_id = 4821 AND deleted_at IS NOT NULL;` retrieves every deleted transaction, satisfying regulatory proof requirements without compromising active production data.