--1
SELECT 
SUM(CASE
  WHEN device_type	= 'laptop' THEN 1
  ELSE 0
END) laptop_views,
SUM(CASE
  WHEN device_type IN ('tablet','phone') THEN 1
  ELSE 0
END) mobile_views
FROM viewership;
--2
SELECT *,
CASE
    WHEN x+y>z THEN 'Yes'
    WHEN x+y<=z THEN 'No'
END triangle
FROM Triangle
--3
SELECT 
ROUND(CAST(100 AS DECIMAL) * 
CAST(SUM(CASE
  WHEN call_category = 'n/a' OR call_category IS NULL THEN 1
  ELSE 0
END) AS DECIMAL)
/CAST(COUNT(*) AS DECIMAL),1) as uncategorised_call_pct
FROM callers
--3.1
SELECT
ROUND(100.0 * 
  SUM(CASE 
    WHEN call_category IS NULL OR call_category = 'n/a' THEN 1
    ELSE 0
  END)
  /COUNT(*), 1) AS uncategorised_call_pct
FROM callers
--4
select  name
from Customer
where coalesce(referee_id,0) <> 2;
--5
select survived,
sum(case when pclass = 1 then 1 else 0 end) as first_class,
sum(case when pclass = 2 then 1 else 0 end) as second_class,
sum(case when pclass = 3 then 1 else 0 end) as third_class
from titanic
group by survived;

