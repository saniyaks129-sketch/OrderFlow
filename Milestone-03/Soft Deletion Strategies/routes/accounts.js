const express = require('express');
const router = express.Router();
const db = require('../db');

// Move 04: Get active accounts
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM accounts WHERE deleted_at IS NULL ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Move 03: Soft Delete Account
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      'UPDATE accounts SET deleted_at = NOW() WHERE id = $1 AND deleted_at IS NULL RETURNING *',
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Account not found or already deleted' });
    }
    res.json({ message: 'Account soft deleted successfully', account: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;