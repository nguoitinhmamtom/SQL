--1
select a.continent,floor(avg(b.population)) from country as a 
inner join city as b
on a.code=b.countrycode
group by a.continent;
--2
SELECT 
  ROUND(COUNT(b.email_id)*1.0/COUNT(a.email_id),2) AS activation_rate
FROM emails AS a  
LEFT JOIN texts AS b 
ON a.email_id=b.email_id AND b.signup_action = 'Confirmed'
--3
SELECT b.age_bucket,
ROUND(SUM(CASE WHEN a.activity_type='send' THEN a.time_spent ELSE 0 END)
/SUM(CASE WHEN a.activity_type <> 'chat' THEN a.time_spent ELSE 0 END) *100.0,2)
AS send_perc,
ROUND(SUM(CASE WHEN a.activity_type='open' THEN a.time_spent ELSE 0 END)
/SUM(CASE WHEN a.activity_type <> 'chat' THEN a.time_spent ELSE 0 END) *100.0,2)
AS open_perc
FROM activities AS a  
INNER JOIN age_breakdown AS b  
ON a.user_id=b.user_id
GROUP BY b.age_bucket
--4
SELECT a.customer_id
AS product FROM customer_contracts AS a
INNER JOIN products AS b 
ON a.product_id=b.product_id 
GROUP BY a.customer_id
HAVING count(distinct(b.product_category))=3 
--5
SELECT a.employee_id, a.name, COUNT(b.reports_to) AS reports_count
,ROUND(AVG(b.age),0) AS average_age
FROM Employees AS a
LEFT JOIN Employees AS b
ON a.employee_id=b.reports_to 
GROUP BY b.reports_to
HAVING reports_count <> 0
ORDER BY a.employee_id
--6
SELECT a.product_name,SUM(b.unit) AS unit
FROM Products AS a
INNER JOIN Orders AS b
ON a.product_id=b.product_id AND b.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY b.product_id
HAVING unit>=100
--7
