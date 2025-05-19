-- File: Assessment_Q3.sql
-- Objective: Find active plans (savings or investment) with no deposit transaction in the last 365 days.
-- Output: plan_id, owner_id, type (Savings or Investment), last_transaction_date, inactivity_days.

WITH plan_last_tx AS (
    -- Determine the last transaction date for each plan
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
          WHEN p.is_regular_savings = 1 THEN 'Savings'
          WHEN p.is_a_fund = 1       THEN 'Investment'
          ELSE 'Other'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s
      ON p.id = s.plan_id  -- assuming savings account records link to plan_id
    GROUP BY p.id, p.owner_id, type
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    -- Calculate days since the last transaction
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM plan_last_tx
-- Filter plans with last transaction older than 365 days or none at all
WHERE last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
   OR last_transaction_date IS NULL;
