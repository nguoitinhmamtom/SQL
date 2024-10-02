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
--5 bài này e tra tính moving average ý, chứ em làm theo lag ko ra được
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
(SELECT category,product,SUM(spend) AS total_spend,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS rank1
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category,product)
SELECT category,product,total_spend
FROM cte 
WHERE rank1 < 3
--8
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
#####
--1
WITH cte AS (
    SELECT customer_id,
CASE 
    WHEN order_date = customer_pref_delivery_date THEN 'immediate'
    WHEN order_date <> customer_pref_delivery_date THEN 'scheduled'
END kind_of_the_order,
RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS rank1
FROM Delivery)
SELECT ROUND(COUNT(kind_of_the_order)/(SELECT COUNT(kind_of_the_order) FROM cte WHERE rank1 = 1)*100,2) AS immediate_percentage
FROM cte
WHERE kind_of_the_order = 'immediate'AND rank1 = 1
--2 em dùng LEAD() - event_date ko ra, nếu như ngày ở LEAD() < ngày ở event_date và khác tháng thì chênh lệch số này hơn 50, nên em dùng DATEDIFF
WITH cte1 AS (
SELECT player_id, event_date,
LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS next_day
FROM Activity),
cte2 AS (SELECT player_id,MIN(event_date) AS first_day FROM Activity GROUP BY player_id)
SELECT ROUND(COUNT(DISTINCT cte1.player_id)/(SELECT COUNT(DISTINCT player_id) FROM Activity),2) AS fraction 
FROM cte1 
INNER JOIN cte2 ON cte1.player_id=cte2.player_id
WHERE (cte1.player_id,cte1.event_date)=(cte2.player_id,cte2.first_day) AND 
DATEDIFF(cte1.next_day, cte1.event_date) = 1
--3 mình ko dùng subquery ở lệnh case when ạ, em muốn rút ngắn code bằng cách thêm lệnh and id not in (select max(id) from seat) nhưng ko được 
WITH cte AS(
SELECT id,
CASE
    WHEN id%2=0 THEN LAG(student) OVER(ORDER BY id)
    WHEN id%2=1 THEN LEAD(student) OVER(ORDER BY id)
    END student 
FROM seat)
SELECT cte.id, COALESCE(cte.student,seat.student) AS student 
FROM seat
INNER JOIN cte on cte.id=seat.id
--4 
