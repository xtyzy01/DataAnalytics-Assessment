-- File: Assessment_Q1.sql
-- Objective: Identify customers who have both a funded savings plan and a funded investment plan.
-- Output: owner_id, name, savings_count, investment_count, total_deposits.

SELECT 
    u.id AS owner_id,
            CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(savings_counts.savings_count, 0) AS savings_count,
    COALESCE(investment_counts.investment_count, 0) AS investment_count,
    COALESCE(deposits.total_deposits, 0) AS total_deposits
FROM users_customuser u

-- Subquery: count of savings plans per user (is_regular_savings = 1)
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
) AS savings_counts
  ON u.id = savings_counts.owner_id

-- Subquery: count of investment plans per user (is_a_fund = 1)
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
) AS investment_counts
  ON u.id = investment_counts.owner_id

-- Subquery: total deposits per user from savings accounts
LEFT JOIN (
    SELECT owner_id, SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
) AS deposits
  ON u.id = deposits.owner_id

-- Filter to users having at least one savings plan AND one investment plan
WHERE COALESCE(savings_counts.savings_count, 0) > 0
  AND COALESCE(investment_counts.investment_count, 0) > 0

-- Sort by total deposits descending
ORDER BY total_deposits DESC;
