# Pre-Refactor Soft Deletion Audit Report

## Hard Delete Audit Trail
The following hard `DELETE` queries were identified in the codebase prior to refactoring:

| File Path | Line Number | Table Affected | Consequence of Permanent Deletion |
|---|---|---|---|
| `src/routes/users.js` | ~line 42 | `users` | Permanently destroys user identity, breaking regulatory compliance and customer historical records. |
| `src/routes/accounts.js` | ~line 38 | `accounts` | Deletes bank account records, making historical balance reconciliation and audits impossible. |
| `src/routes/transactions.js` | ~line 51 | `transactions` | Removes financial transaction records, violating legal 7-year retention requirements and causing ledger mismatches. |

## Tables Excluded from Soft Deletion
- `session_tokens` / `auth_tokens`: Excluded because temporary authentication sessions must be hard-purged on logout for security and storage efficiency.