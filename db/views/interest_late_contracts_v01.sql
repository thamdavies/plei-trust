WITH client_timezone AS (
    SELECT (now() AT TIME ZONE 'Asia/Ho_Chi_Minh')::date AS date
),
interest_payment_schedule AS (
    SELECT
        contract_id,
        CASE WHEN COUNT(contract_id) FILTER (WHERE payment_status = 'paid') = COUNT(contract_id) THEN
            MAX(contract_interest_payments.to)
        ELSE
            MIN(contract_interest_payments.to)
        END AS date,
        MAX(contract_interest_payments.to) as end_date
    FROM contract_interest_payments
	GROUP BY contract_id
)
SELECT c.*
FROM contracts AS c
CROSS JOIN client_timezone
WHERE (SELECT date FROM interest_payment_schedule WHERE interest_payment_schedule.contract_id = c.id) <= client_timezone.date
  AND client_timezone.date <= (SELECT end_date FROM interest_payment_schedule WHERE interest_payment_schedule.contract_id = c.id)
  AND c.status != 'closed'
