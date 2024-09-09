--1 
select name
from STUDENTS
where marks>75
order by right(name,3),id
--2 
select user_id,
concat(upper(left(name,1)),lower(right(name, length(name)-1))) as name
from Users
--3
SELECT manufacturer,
'$' || round(sum(total_sales)/1000000) || ' ' || 'million' as sale
FROM pharmacy_sales
group by manufacturer
order by floor(sum(total_sales)/1000000) desc, manufacturer
--4
SELECT manufacturer,
'$' || round(sum(total_sales)/1000000) || ' ' || 'million' as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer
--5
SELECT
EXTRACT(month from submit_date) as mth
,product_id
,round(avg(stars),2) as avg_stars
FROM reviews
group by EXTRACT(month from submit_date) 
,product_id
order by mth, product_id
--6
select tweet_id
from tweets
where length(content) >=15
--7
select count(distinct(user_id)) as active_users ,
activity_date as day
from activity
where (activity_date between '2019-06-28' and '2019-07-27')
group by activity_date
--8
select 
count(id) as employees_id
from employees
where (extract(month from joining_date) between 1 and 7)
and extract(month from joining_date) = 2022
--9
select position( 'a' in first_name) from worker where first_name = 'Amitah'
--10
select substring(title, length(winery)+2,4) from winemag_p2
where country = 'Macedonia'
