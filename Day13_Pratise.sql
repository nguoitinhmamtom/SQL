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
ON a.page_id=b.page_id;
--4.1
SELECT page_id 
FROM pages
WHERE NOT page_id IN (SELECT DISTINCT(page_id)
FROM page_likes)
ORDER BY page_id;
--5

WHERE b.page_id IS NULL
ORDER BY page_id
--4
