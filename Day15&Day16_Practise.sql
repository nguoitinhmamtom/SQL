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
--5.1
WITH cte AS
(SELECT user_id,tweet_date,tweet_count,
COALESCE(LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date),'0') AS LAG1,
COALESCE(LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date),'0') AS LAG2,
RANK() OVER(PARTITION BY user_id ORDER BY tweet_date) AS rank1
FROM tweets)
SELECT user_id,tweet_date,
CASE
  WHEN rank1 = 1 THEN ROUND(tweet_count/1,2)
  WHEN rank1 = 2 THEN ROUND((tweet_count+LAG1)/2.00 ,2)
  ELSE ROUND((tweet_count+LAG1+LAG2)/3.00 ,2)
END rolling_avg_3d
FROM cte
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
--3  
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
--3.1 
SELECT 
CASE
    WHEN id % 2 <> 0 AND id = (SELECT COUNT(*) FROM Seat) THEN id
    WHEN id % 2 = 0 THEN id - 1
    ELSE id + 1
END id, student
FROM Seat 
ORDER BY id
--4
WITH cte AS (
SELECT visited_on, SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount, 
ROUND(AVG(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount,
RANK() OVER(ORDER BY visited_on) AS rank1
FROM (SELECT visited_on, SUM(amount) AS amount
FROM customer
GROUP BY visited_on) AS a)
SELECT visited_on, amount, average_amount
FROM cte
WHERE rank1>6
--4.1
WITH cte AS(
SELECT visited_on,amount,
COALESCE(LAG(amount,1) OVER(ORDER BY visited_on),'0') AS LAG1,
COALESCE(LAG(amount,2) OVER(ORDER BY visited_on),'0') AS LAG2,
COALESCE(LAG(amount,3) OVER(ORDER BY visited_on),'0') AS LAG3,
COALESCE(LAG(amount,4) OVER(ORDER BY visited_on),'0') AS LAG4,
COALESCE(LAG(amount,5) OVER(ORDER BY visited_on),'0') AS LAG5,
COALESCE(LAG(amount,6) OVER(ORDER BY visited_on),'0') AS LAG6,
RANK() OVER(ORDER BY visited_on) AS rank1
FROM
(SELECT visited_on, SUM(amount) AS amount
FROM customer
GROUP BY visited_on) AS a)

SELECT visited_on,
CASE 
    WHEN rank1=1 THEN ROUND(amount,2)
    WHEN rank1=2 THEN ROUND(amount+LAG1,2)
    WHEN rank1=3 THEN ROUND(amount+LAG1+LAG2,2)
    WHEN rank1=4 THEN ROUND(amount+LAG1+LAG2+LAG3,2)
    WHEN rank1=5 THEN ROUND(amount+LAG1+LAG2+LAG3+LAG4,2)
    WHEN rank1=6 THEN ROUND(amount+LAG1+LAG2+LAG3+LAG4+LAG5,2)
    ELSE ROUND(amount+LAG1+LAG2+LAG3+LAG4+LAG5+LAG6,2)
END amount,
CASE 
    WHEN rank1=1 THEN ROUND(amount,2)
    WHEN rank1=2 THEN ROUND((amount+LAG1)/2,2)
    WHEN rank1=3 THEN ROUND((amount+LAG1+LAG2)/3,2)
    WHEN rank1=4 THEN ROUND((amount+LAG1+LAG2+LAG3)/4,2)
    WHEN rank1=5 THEN ROUND((amount+LAG1+LAG2+LAG3+LAG4)/5,2)
    WHEN rank1=6 THEN ROUND((amount+LAG1+LAG2+LAG3+LAG4+LAG5)/6,2)
    ELSE ROUND((amount+LAG1+LAG2+LAG3+LAG4+LAG5+LAG6)/7,2)
END average_amount
FROM cte
WHERE rank1 > 6
--5
WITH cte AS(
SELECT pid, tiv_2015,tiv_2016, COUNT(tiv_2015) OVER(PARTITION BY tiv_2015) AS num,
COUNT(CONCAT(lat,lon)) OVER(PARTITION BY CONCAT(lat,lon)) AS location
FROM Insurance)
SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM cte
WHERE num > 1 AND location = 1 
--6
WITH cte AS 
(SELECT b.name AS Department,a.name AS Employee,a.salary AS Salary,
DENSE_RANK() OVER(PARTITION BY b.name ORDER BY a.salary DESC) AS rank1
FROM Employee AS a
INNER JOIN Department AS b ON a.departmentId=b.id)
SELECT Department,Employee,Salary
FROM cte
WHERE rank1 < 4
--7
SELECT person_name
FROM (SELECT person_name , SUM(Weight) OVER(ORDER BY Turn) AS total_weight
FROM Queue) AS a
WHERE total_weight<=1000
ORDER BY total_weight DESC
LIMIT 1
--8
SELECT product_id, 
FIRST_VALUE(new_price) OVER(PARTITION BY product_id ORDER BY change_date DESC) AS price
FROM Products
WHERE change_date <= '2019-08-16'
UNION 
SELECT product_id, 10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16'

câu 2 với câu 8 em đọc đề phát hoảng ý, tại code mãi ko ra :<<
