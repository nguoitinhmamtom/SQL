/* Bước 1: Tính giá trị R, F, M */
select * from customer;
select * from sales;
select * from segment_score;

with customer_rfm as (
select 
a.customer_id,
current_date-MAX(order_date) as r,
count(distinct order_id) as f,
sum(sales) as m
from sales as a
join customer as b
on a.customer_id = b.customer_id
group by a.customer_id)

/* Bước 2:  Chia các giá trị trên thang điểm từ 1-5 */
,rfm_score as(
selecT customer_id,
ntile(5) over(order by r desc) as r_score,
ntile(5) over(order by f) as f_score,
ntile(5) over(order by m) as m_score
from customer_rfm)

/* Bước 3: Phân nhóm theo 125 tổ hợp R-F-M */
,rfm_final as (
select customer_id,
cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as rfm_score
from rfm_score)

select segment, count(*)
from(select d.customer_id,c.segment
from segment_score as c
join rfm_final as d
on d.rfm_score=c.scores) as c
group by segment
order by count(*);

/* project 3 */

/* 1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE */
select productline, year_id, dealsize,
sum(sales) as revenue
from sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize;

/* 2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
select month_id, sum(sales) as revenue, count(distinct ordernumber) as order_number
from sales_dataset_rfm_prj_clean
group by month_id;

/* 3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
select productline, count(distinct ordernumber) as order_number
from sales_dataset_rfm_prj_clean
where month_id = '11'
group by productline;

/* 4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK */
select year_id, productline, revenue, rank() over(order by revenue desc)as rank
from (select year_id, productline, sum(sales) as revenue
from sales_dataset_rfm_prj_clean
where country = 'UK'
group by year_id, productline) as a;

/* 5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23) */
with customername_rfm as (
select customername,
current_date - max(orderdate) as r,
count(distinct ordernumber) as f,
sum(sales) as m
from public.sales_dataset_rfm_prj_clean
group by customername)

, rfm_score as (
select customername,
ntile(5) over(order by r desc) as r_score,
ntile(5) over(order by f) as f_score,
ntile(5) over(order by m) as m_score
from customername_rfm
)

,rfm_final as (
select customername, 
cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as rfm_score
from rfm_score)

select a.customername, b.segment
from rfm_final as a
join segment_score as b
on a.rfm_score = b.scores
