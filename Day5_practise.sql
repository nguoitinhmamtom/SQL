-1
select DISTINCT(CITY) from STATION WHERE ID%2=0
-2
select count(city) -count(distinct(city)) from station
-3

-4
SELECT ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) 
AS DECIMAL),1)
FROM items_per_order
-5
select candidate_id from candidates
where skill IN ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill) =3
order by candidate_id
-6
select user_id,
date(max(post_date))-date(min(post_date)) as between_day
from posts
where post_date BETWEEN '2021-01-01' and '2022-01-01'
group by user_id
having date(max(post_date))-date(min(post_date)) > 1
-7
select user_id,
date(max(post_date))-date(min(post_date)) as between_day
from posts
where post_date BETWEEN '2021-01-01' and '2022-01-01'
group by user_id
having date(max(post_date))-date(min(post_date)) > 1
-8
select manufacturer, 
count(drug) as drug_count,
abs(sum(total_sales - cogs)) as total_loss
from pharmacy_sales
where (total_sales-cogs) <= 0
group by manufacturer
order by total_loss desc
-9
select *
from Cinema
where id% 2 = 1 and description<>'boring'
order by rating desc
-10
select teacher_id, count(distinct(subject_id)) as cnt
from teacher
group by teacher_id
-11
select user_id,
count(follower_id) as followers_count
from followers
group by user_id
order by user_id
-12
select class
from courses
group by class
having count(student) >=5
