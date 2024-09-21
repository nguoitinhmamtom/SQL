--1
WITH a AS (
SELECT COUNT(company_id) AS duplicate_companies
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(company_id) >1)
SELECT COUNT(a.duplicate_companies)
FROM a 
--2
WITH a AS
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE category = 'appliance' AND EXTRACT( year FROM transaction_date) = 2022
GROUP BY category, product
ORDER BY total_spend DESC 
LIMIT 2),
b AS 
( SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE category = 'electronics' AND EXTRACT( year FROM transaction_date) = 2022
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2)
SELECT category,product,total_spend
FROM a
UNION ALL
SELECT category,product,total_spend
FROM b 
--3
WITH a AS 
(SELECT COUNT(DISTINCT(policy_holder_id)) AS policy_count 
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>2)
SELECT SUM(policy_count)
FROM a
--4 
SELECT a.page_id
FROM pages AS a  
LEFT JOIN page_likes AS b  
ON a.page_id=b.page_id
WHERE b.page_id IS NULL
ORDER BY page_id;
--4.1
SELECT page_id 
FROM pages
WHERE NOT page_id IN (SELECT DISTINCT(page_id)
FROM page_likes)
ORDER BY page_id;
--5
WITH a AS
(SELECT month AS current_month,(user_id) AS current_users 
FROM user_actions
WHERE EXTRACT(year FROM event_date) = 2022 
AND EXTRACT(month FROM event_date) = 7
GROUP BY user_id,month),
b AS 
(SELECT month AS last_month,(user_id) AS last_users 
FROM user_actions
WHERE EXTRACT(year FROM event_date) = 2022 
AND EXTRACT(month FROM event_date) = 6
GROUP BY user_id,month), 
c AS 
(SELECT a.current_month,a.current_users FROM a 
LEFT JOIN b  
ON a.current_users=b.last_users
WHERE b.last_users IS NOT NULL)
SELECT current_month AS mth, COUNT(current_users) AS monthly_active_user
FROM c  
GROUP BY mth
--5.1
SELECT
 EXTRACT(month from event_date) AS mth,
 COUNT(DISTINCT(user_id)) AS monthly_active_user
FROM user_actions 
WHERE user_id IN (
  SELECT 
  	DISTINCT(user_id)
  FROM user_actions
  WHERE EXTRACT(month from event_date) = 6 AND EXTRACT(year from event_date) = 2022
  )
AND EXTRACT(month from event_date) = 7 AND EXTRACT(year from event_date) = 2022
GROUP BY mth
--5.2
select extract(month from event_date) as mth, count(distinct(user_id)) as monthly_active_users
from user_actions
where user_id in (select distinct(user_id) from user_actions where extract(year from event_date)= 2022 and  extract(month from event_date)=6)
and extract(year from event_date)= 2022 and  extract(month from event_date)=7
group by mth
--6
select left(trans_date,7) as month, country, count(id) as trans_count, 
count(case when state = 'approved' then state else null end) as approved_count, sum(amount) as trans_total_amount, 
sum(case when state ='approved' then amount else 0 end) as approved_total_amount 
from transactions 
group by left(trans_date, 7), country;
--7
with a as 
(select min(year) as min_year,product_id from sales group by product_id)
select b.product_id, b.year as first_year, b.quantity, b.price 
from Sales b
inner join a 
on a.product_id=b.product_id and a.min_year=b.year
--8
select customer_id
from customer
group by customer_id
having count(distinct product_key) = (select count(product_key) from product)
--9
select employee_id from Employees
where salary < 30000 and not manager_id in (select employee_id from Employees)
order by employee_id
--10

