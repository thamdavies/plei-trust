SELECT 
  c.id AS contract_id,
  c.code AS contract_code,
  c.contract_date,
  c.loan_amount,
  c.interest_rate,
  c.status AS contract_status,
  c.customer_id,
  c.branch_id,
  cip.id AS interest_payment_id,
  cip.from AS interest_period_from,
  cip.to AS interest_period_to,
  cip.amount AS interest_amount,
  cip.total_amount,
  cip.total_paid,
  cip.payment_status,
  (cip.total_amount - cip.total_paid) AS remaining_amount,
  (CURRENT_DATE - cip.to) AS days_overdue
FROM contracts c
INNER JOIN contract_interest_payments cip ON cip.contract_id = c.id
WHERE 
  c.status = 'active'
  AND cip.to < CURRENT_DATE
  AND cip.payment_status = 'unpaid'
ORDER BY 
  cip.to ASC,
  c.code ASC;