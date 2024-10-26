1. 
select 
FORMAT_DATE('%Y-%m', created_at) as month_year,
sum(user_id) as total_user,
sum(order_id) as total_order,
from bigquery-public-data.thelook_ecommerce.orders 
where FORMAT_DATE('%Y-%m', created_at) between '2019-01'and'2022-04' and status <> 'Cancelled'
group by 1
2. 
with cte as (select 
FORMAT_DATE('%Y-%m', a.created_at) as month_year,
count(distinct a.user_id) as distinct_users,
count(a.order_id) as total_order,
sum(b.sale_price) as total_sale_price
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.order_id
where FORMAT_DATE('%Y-%m', a.created_at) between '2019-01'and'2022-04'
group by 1)
select month_year, distinct_users, round(total_sale_price/total_order,2) as average_order_value
from cte
3. 

https://docs.google.com/spreadsheets/d/1_l0GUawirlfubumpRY83oyjUB6LxRr218sgM646i8ic/edit?usp=sharing
