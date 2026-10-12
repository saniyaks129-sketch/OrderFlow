const express = require('express');
const router = express.Router();
const db = require('../db');

// Move 04: Get all active users
router.get('/', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM users WHERE deleted_at IS NULL ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get single active user
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM users WHERE id = $1 AND deleted_at IS NULL', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found or deleted' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Move 03: Replace Hard Delete with Soft Delete UPDATE
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      'UPDATE users SET deleted_at = NOW() WHERE id = $1 AND deleted_at IS NULL RETURNING *',
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found or already deleted' });
    }
    res.json({ message: 'User soft deleted successfully', user: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;