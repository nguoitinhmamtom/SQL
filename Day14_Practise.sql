--1
SELECT TO_CHAR(transaction_date,'YYYY') AS year,product_id,spend AS curr_year_spend, 
LAG(spend) OVER(PARTITION BY product_id ORDER BY TO_CHAR(transaction_date,'YYYY')) AS prev_year_spend,
ROUND((spend-
LAG(spend) OVER(PARTITION BY product_id ORDER BY TO_CHAR(transaction_date,'YYYY')))/
LAG(spend) OVER(PARTITION BY product_id ORDER BY TO_CHAR(transaction_date,'YYYY'))*100,2) AS yoy_rate
FROM user_transactions
--2
SELECT DISTINCT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount
--3
