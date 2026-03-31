SELECT
  ft.id,
  ft.branch_id,
  ft.transaction_date,
  ft.transactable_type_code,
  c.code AS contract_code,
  c.asset_name,
  u.id AS transaction_by_id,
  u.full_name AS transaction_by,
  ft.party_name AS customer_name,
  ft.description,
  CASE
    WHEN NOT tt.is_income AND ft.amount < 0 THEN ft.amount * -1
    WHEN tt.is_income AND ft.amount > 0 THEN ft.amount
    ELSE 0
  END AS amount_in,
  CASE
    WHEN NOT tt.is_income AND ft.amount >= 0 THEN ft.amount * -1
    WHEN tt.is_income AND ft.amount < 0 THEN ft.amount
    ELSE 0
  END AS amount_out,
  ft.notes,
  ft.created_at
FROM financial_transactions ft
JOIN transaction_types tt ON tt.code = ft.transaction_type_code
LEFT JOIN users u ON u.id = ft.created_by_id
LEFT JOIN contracts c ON ft.transactable_type = 'Contract' AND ft.transactable_id = c.id
