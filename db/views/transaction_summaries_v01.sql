-- SELECT
--   a.id,
--   'activity'::varchar AS source_type,
--   a.branch_id,
--   a.created_at::date AS transaction_date,
--   ct.name AS contract_type_name,
--   c.code AS contract_code,
--   c.asset_name,
--   COALESCE(u.full_name, 'Hệ thống') AS transaction_by,
--   cust.full_name AS customer_name,
--   a.key AS activity_key,
--   NULL::text AS description,
--   COALESCE((regexp_match(a.parameters, 'debit_amount:[ ]*''?([0-9.]+)'))[1], '0')::decimal AS raw_debit_amount,
--   COALESCE((regexp_match(a.parameters, 'credit_amount:[ ]*''?([0-9.]+)'))[1], '0')::decimal AS raw_credit_amount,
--   (regexp_match(a.parameters, 'note:[ ]*''?([^'':\n][^:\n]*)'))[1] AS notes,
--   a.created_at
-- FROM activities a
-- JOIN contracts c ON c.id = a.trackable_id AND a.trackable_type = 'Contract'
-- JOIN contract_types ct ON ct.code = c.contract_type_code
-- JOIN customers cust ON cust.id = c.customer_id
-- LEFT JOIN users u ON u.id = a.owner_id
-- WHERE a.trackable_type = 'Contract'

-- UNION ALL

-- SELECT
--   ft.id,
--   'transaction'::varchar AS source_type,
--   ft.recordable_id AS branch_id,
--   ft.transaction_date,
--   NULL::text AS contract_type_name,
--   NULL::text AS contract_code,
--   NULL::text AS asset_name,
--   u.full_name AS transaction_by,
--   ft.party_name AS customer_name,
--   NULL::text AS activity_key,
--   ft.description,
--   CASE WHEN tt.is_income THEN ft.amount ELSE 0 END AS raw_debit_amount,
--   CASE WHEN NOT tt.is_income THEN ft.amount ELSE 0 END AS raw_credit_amount,
--   NULL::text AS notes,
--   ft.created_at
-- FROM financial_transactions ft
-- JOIN transaction_types tt ON tt.code = ft.transaction_type_code
-- LEFT JOIN users u ON u.id = ft.created_by_id
-- WHERE ft.recordable_type = 'Branch'

SELECT
  'activity'::varchar AS source_type,
  a.branch_id,
  a.created_at::date AS transaction_date,
  ct.name AS contract_type_name,
  c.code AS contract_code,
  c.asset_name,
  COALESCE(u.full_name, 'Hệ thống') AS transaction_by,
  cust.full_name AS customer_name,
  a.key AS activity_key,
  NULL::text AS description,
  COALESCE((regexp_match(a.parameters, 'debit_amount:[ ]*''?([0-9.]+)'))[1], '0')::decimal AS raw_debit_amount,
  COALESCE((regexp_match(a.parameters, 'credit_amount:[ ]*''?([0-9.]+)'))[1], '0')::decimal AS raw_credit_amount,
  (regexp_match(a.parameters, 'note:[ ]*''?([^'':\n][^:\n]*)'))[1] AS notes,
  a.created_at
FROM activities a
JOIN contracts c ON c.id = a.trackable_id AND a.trackable_type = 'Contract'
JOIN contract_types ct ON ct.code = c.contract_type_code
JOIN customers cust ON cust.id = c.customer_id
LEFT JOIN users u ON u.id = a.owner_id
WHERE a.trackable_type = 'Contract'

UNION ALL

SELECT
  'transaction'::varchar AS source_type,
  ft.recordable_id AS branch_id,
  ft.transaction_date,
  NULL::text AS contract_type_name,
  NULL::text AS contract_code,
  NULL::text AS asset_name,
  u.full_name AS transaction_by,
  ft.party_name AS customer_name,
  NULL::text AS activity_key,
  ft.description,
  0 AS raw_debit_amount,
  0 AS raw_credit_amount,
  NULL::text AS notes,
  ft.created_at
FROM financial_transactions ft
JOIN transaction_types tt ON tt.code = ft.transaction_type_code
LEFT JOIN users u ON u.id = ft.created_by_id
WHERE ft.recordable_type = 'Branch' AND ft.transaction_type_code NOT IN ('income_interest', 'expense_interest')
