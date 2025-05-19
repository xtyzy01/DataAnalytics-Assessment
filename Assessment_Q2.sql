-- File: Assessment_Q2.sql
-- Objective: Calculate average number of transactions per customer per month from savings_savingsaccount.
-- Categorize users as High Frequency (>=10/month), Medium (3-9), or Low (<=2).
-- Output: frequency_category, customer_count, avg_transactions_per_month.

SELECT
    CASE
        WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
        WHEN avg_tx_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT 
        owner_id,
        AVG(monthly_count) AS avg_tx_per_month
    FROM (
        SELECT 
            owner_id,
            DATE_FORMAT(transaction_date, '%m-%Y') AS month_year,
            COUNT(*) AS monthly_count
        FROM savings_savingsaccount
        WHERE transaction_date IS NOT NULL
        GROUP BY owner_id, DATE_FORMAT(transaction_date, '%m-%Y')
    ) AS monthly_transactions
    GROUP BY owner_id
) AS user_monthly_avg
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;

