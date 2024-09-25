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
WITH cte AS (SELECT user_id,spend,transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rank1	
FROM transactions)
SELECT user_id,spend,transaction_date
FROM cte 
WHERE rank1 = 3
--4
WITH cte AS (SELECT transaction_date,user_id, 
COUNT(product_id) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS purchase_count,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank1
FROM user_transactions)
SELECT transaction_date,user_id, purchase_count
FROM cte
WHERE rank1 = 1
ORDER BY transaction_date 
--5
SELECT  user_id,tweet_date, 
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;
--6
WITH cte AS (
SELECT *, 
transaction_timestamp-
LAG(transaction_timestamp,1) OVER(PARTITION BY merchant_id,credit_card_id,amount ORDER BY transaction_timestamp) AS diff
FROM transactions)
SELECT COUNT(merchant_id) AS payment_count
FROM cte  
WHERE (EXTRACT(HOUR FROM diff)*60+EXTRACT(minute FROM diff) <= 10
--7
WITH cte AS 
(SELECT a.artist_name AS artist_name,
DENSE_RANK() OVER(ORDER BY COUNT(c.song_id) DESC) AS artist_rank
FROM artists AS a  
INNER JOIN songs AS b ON a.artist_id=b.artist_id
INNER JOIN global_song_rank AS c ON b.song_id=c.song_id
WHERE c.rank < 11
GROUP BY a.artist_name)
SELECT *
FROM cte 
WHERE artist_rank < 6
