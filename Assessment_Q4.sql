-- File: Assessment_Q4.sql
-- Objective: Estimate customer lifetime value (CLV).
-- Compute: tenure in months since date_joined, total transaction value, and CLV.
-- CLV = (total_transactions/tenure)*12*(0.001 * average_transaction_value).
-- Output: customer_id, name, tenure_months, total_transactions, estimated_clv.

WITH user_stats AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        -- Calculate tenure in months
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        SUM(s.confirmed_amount) AS total_transactions,
        COUNT(s.confirmed_amount) AS tx_count
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
      ON u.id = s.owner_id
    GROUP BY u.id, u.first_name, u.last_name
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
      -- CLV formula breakdown
      (total_transactions / tenure_months)         -- avg annual transactions per month
      * 12                                        -- scale to yearly
      * ((total_transactions / tx_count) * 0.001) -- avg_profit_per_transaction (0.1% of avg transaction)
    , 2) AS estimated_clv
FROM user_stats
-- Consider only users with non-zero tenure and transactions
WHERE tenure_months > 0
  AND tx_count > 0
ORDER BY estimated_clv DESC;
