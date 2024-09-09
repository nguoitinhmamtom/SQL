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
