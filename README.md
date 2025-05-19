# DataAnalytics-Assessment
DataAnalytics Assessment README
Question 1: Customers with Both Funded Savings and Investment Plans
Goal: Identify users who have at least one savings plan (is_regular_savings = 1) and at least one investment plan (is_a_fund = 1), along with counts of each plan type and their total deposits.
Approach:
•	Join the users_customuser table with three aggregated subqueries:
o	One counts each user’s savings plans (savings_count).
o	Another counts each user’s investment plans (investment_count).
o	A third sums confirmed deposits (total_deposits) from savings_savingsaccount.
•	Filter to keep users having both savings and investment plans (savings_count > 0 AND investment_count > 0).
•	Sort results by total_deposits descending.
Assumptions:
•	users_customuser contains user IDs and names.
•	Plan types are flagged in plans_plan.
•	Deposits linked to users are stored in savings_savingsaccount by owner_id.
Challenges:
•	Interpreting "funded plan" as the existence of plans plus summing deposits over potentially multiple accounts.
•	Using COALESCE to handle missing data gracefully.
________________________________________
Question 2: Transaction Frequency Categorization
Goal: Calculate each user’s average monthly transaction count from savings_savingsaccount, then categorize them as High (≥10), Medium (3–9), or Low (≤2) frequency.
Approach:
1.	Aggregate transactions monthly per user (owner_id and DATE_FORMAT(transaction_date, '%Y-%m')), counting transactions as monthly_count.
2.	Compute the average monthly transactions per user (avg_tx_per_month).
3.	Categorize users using a CASE statement based on their average frequency.
4.	Group results by frequency category to count customers and average transactions per category.
Assumptions:
•	transaction_date exists for all transactions.
•	Only users with transactions are included.
Challenges:
•	Two-step aggregation to correctly compute averages without bias from months without transactions.
•	Ordering categories logically (High → Medium → Low) using a custom ORDER BY with CASE.
________________________________________
Question 3: Inactive Plans (No Deposits in Last 365 Days)
Goal: List all active plans (savings or investment) with no deposit activity in the last 365 days. Show each plan’s last transaction date and days inactive.
Approach:
1.	Left join plans_plan to savings_savingsaccount on plan_id, calculating the latest transaction date (last_transaction_date) per plan.
2.	Use a CASE statement to label plan type as "Savings" or "Investment".
3.	Filter for plans where last_transaction_date is either null or more than 365 days ago.
4.	Calculate inactivity duration with DATEDIFF.
Assumptions:
•	plan_id links deposits to plans.
•	All plans are considered active (no explicit status).
Challenges:
•	Including plans with no transactions (null last transaction dates).
•	Structuring logic with CTE/subquery for clarity.
•	Using MySQL date functions correctly for inactivity calculation.
________________________________________
Question 4: Customer Lifetime Value (CLV) Calculation
Goal: For each user, calculate:
•	Tenure (months): Months since date_joined.
•	Total Transactions: Sum of all confirmed_amount.
•	CLV: (total_transactions / tenure) * 12 * avg_profit_per_transaction, where
avg_profit_per_transaction = 0.001 * (total_transactions / transaction_count) (0.1% of average transaction value).
Approach:
1.	Join users_customuser and savings_savingsaccount, grouping by user to compute tenure, total transaction amount, and transaction count.
2.	Calculate CLV per formula within the query.
3.	Round CLV and sort descending.
Assumptions:
•	users_customuser has date_joined, first_name, and last_name.
•	Exclude users with zero transactions or zero tenure to avoid division errors.
•	Profit margin fixed at 0.1%.
Challenges:
•	Correctly implementing the CLV formula with multiple aggregations.
•	Avoiding divide-by-zero errors.
•	Concatenating first and last names for display.


