--bai1
SELECT NAME FROM CITY
WHERE POPULATION > 120000 AND COUNTRYCODE = 'USA'
--bai2
SELECT * FROM CITY 
WHERE COUNTRYCODE = 'JPN'
--bai3
SELECT CITY, STATE FROM STATION
--bai4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'
--4.1
SELECT DISTINCT CITY FROM STATION
WHERE CITY RLIKE '^[AEOIU]'
--bai5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'
--5.1
SELECT DISTINCT CITY FROM STATION
WHERE CITY RLIKE '[AEUOI]$'
--bai6
SELECT DISTINCT CITY FROM STATION
WHERE NOT (CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%')
--6.1
SELECT DISTINCT CITY FROM STATION
WHERE NOT CITY RLIKE '^[AEOIU]'
--bai7
SELECT name FROM Employee
ORDER BY name
--bai8
SELECT name FROM Employee WHERE salary > 2000 AND months <10 ORDER BY employee_id
--bai9
select product_id from Products where low_fats = 'Y' and recyclable = 'Y'
--bai10
select name from Customer where NOT referee_id = '2' or referee_id is null
--bai11
select name , population , area from World where area >= 3000000 or population >= 25000000
--bai12
select distinct author_id as "id" from Views where author_id = viewer_id order by id
--bai13
SELECT part, assembly_step FROM parts_assembly WHERE finish_date IS NULL
--bai14
select * from lyft_drivers where yearly_salary <= 30000 or yearly_salary >= 70000
--bai15
select advertising_channel from uber_advertising where money_spent > 100000
