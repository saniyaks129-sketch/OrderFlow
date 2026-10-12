const express = require('express');
const app = express();
const db = require('./db');

app.use(express.json());

// Routes
app.use('/api/users', require('./routes/users'));
app.use('/api/accounts', require('./routes/accounts'));
app.use('/api/transactions', require('./routes/transactions'));

// Move 04: Admin/Audit Route returning soft-deleted records
app.get('/api/admin/audit/deleted-records', async (req, res) => {
  try {
    const deletedUsers = await db.query('SELECT * FROM users WHERE deleted_at IS NOT NULL');
    const deletedAccounts = await db.query('SELECT * FROM accounts WHERE deleted_at IS NOT NULL');
    const deletedTransactions = await db.query('SELECT * FROM transactions WHERE deleted_at IS NOT NULL');

    res.json({
      deleted_users: deletedUsers.rows,
      deleted_accounts: deletedAccounts.rows,
      deleted_transactions: deletedTransactions.rows
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));