WITH client_timezone AS (
    SELECT (now() AT TIME ZONE 'Asia/Ho_Chi_Minh')::date AS current_date
),
interest_payment_schedule AS (
    SELECT
        contract_id,
        MIN(contract_interest_payments.to) AS date,
        MAX(contract_interest_payments.to) as end_date
    FROM contract_interest_payments
    WHERE payment_status = 'unpaid'
	GROUP BY contract_id
)
SELECT c.*
FROM contracts AS c
CROSS JOIN client_timezone
WHERE client_timezone.current_date <= (SELECT date FROM interest_payment_schedule WHERE interest_payment_schedule.contract_id = c.id)
  AND client_timezone.current_date <= (SELECT end_date FROM interest_payment_schedule WHERE interest_payment_schedule.contract_id = c.id)
  AND c.status != 'closed'