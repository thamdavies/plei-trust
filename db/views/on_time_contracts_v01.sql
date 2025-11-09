WITH must_pay_dates AS (
    SELECT
        contract_id,
        CASE WHEN COUNT(contract_id) FILTER (WHERE payment_status = 'paid') = COUNT(contract_id) THEN
            MAX(contract_interest_payments.to)
        ELSE
            MIN(contract_interest_payments.to)
        END AS date
    FROM contract_interest_payments
    GROUP BY contract_id)
SELECT
    c.*
FROM
    contracts AS c
WHERE
    (SELECT date FROM must_pay_dates WHERE must_pay_dates.contract_id = c.id) >= CURRENT_DATE
    AND c.status != 'closed'

