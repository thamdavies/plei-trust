WITH client_timezone AS (
    SELECT (now() AT TIME ZONE 'Asia/Ho_Chi_Minh')::date AS date
),
interest_payment_schedule AS (
    SELECT
        contract_id,
        MAX(contract_interest_payments.to) AS date
    FROM contract_interest_payments
    GROUP BY contract_id
)
SELECT
    c.*
FROM
    contracts AS c
CROSS JOIN client_timezone
WHERE
    (SELECT date FROM interest_payment_schedule WHERE interest_payment_schedule.contract_id = c.id) < client_timezone.date
    AND c.status != 'closed'
