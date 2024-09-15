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
LECT a.page_id
FROM pages AS a  
LEFT JOIN page_likes AS b  
ON a.page_id=b.page_id 
WHERE b.page_id IS NULL
	
###Mid-course test
	
--1
select distinct(replacement_cost)
from film
order by replacement_cost;
--2
select count(film_id),
case 
	when replacement_cost between '9.99' and '19.99' then 'low' 
	when replacement_cost between '20.00' and '24.99' then 'medium'
	when replacement_cost between '25.00' and '29.99' then 'high'
end a
from film
group by a
--3
select c.title, c.length, cast(a.name as varchar) as category_name
from public.category as a
inner join public.film_category as b
on a.category_id=b.category_id
inner join public.film as c
on b.film_id=c.film_id and a.name in ('Drama','Sports')
order by category_name desc;
--4
select count(c.title) as so_luong,a.name
from public.category as a
inner join public.film_category as b
on a.category_id=b.category_id
inner join public.film as c
on b.film_id=c.film_id 
group by a.name
--5
select b.first_name, b.last_name, count(a.film_id) as so_luong
from film_actor as a
inner join actor as b
on a.actor_id=b.actor_id
group by b.first_name, b.last_name
order by so_luong desc
--6
select a.address, b.customer_id
from public.address as a
left join public.customer as b
on a.address_id=b.address_id
where b.customer_id is null;
--7
select sum(a.amount), d.city
from payment as a
inner join public.customer as b
on a.customer_id=b.customer_id
inner join public.address as c
on b.address_id=c.address_id
inner join public.city as d
on c.city_id=d.city_id
group by d.city
order by sum(a.amount) desc;
--8

