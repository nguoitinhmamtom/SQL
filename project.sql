1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
  
alter table sales_dataset_rfm_prj
alter column ordernumber type int using(trim(ordernumber) :: int),
alter column quantityordered type int using(trim(quantityordered) :: int),
alter column priceeach type numeric using(trim(priceeach) :: numeric),
alter column orderlinenumber type int using(trim(orderlinenumber) :: int),
alter column sales type numeric using(trim(sales) :: numeric),
alter column msrp type int using(trim(msrp) :: int);
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date);
2.Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
  
select ORDERNUMBER from sales_dataset_rfm_prj order by ORDERNUMBER;
select QUANTITYORDERED from sales_dataset_rfm_prj order by QUANTITYORDERED;
select PRICEEACH from sales_dataset_rfm_prj order by PRICEEACH;
select ORDERLINENUMBER from sales_dataset_rfm_prj order by ORDERLINENUMBER;
select SALES from sales_dataset_rfm_prj order by SALES;
select ORDERDATE from sales_dataset_rfm_prj order by ORDERDATE;
3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME. 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 

alter table sales_dataset_rfm_prj
add column  CONTACTLASTNAME varchar, 
add column CONTACTFIRSTNAME varchar, 
update sales_dataset_rfm_prj
set CONTACTLASTNAME = right(CONTACTFULLNAME, length(CONTACTFULLNAME) - position('-' in CONTACTFULLNAME)),
CONTACTFIRSTNAME = substring(CONTACTFULLNAME,1,position('-' in CONTACTFULLNAME)-1)
update sales_dataset_rfm_prj
set CONTACTLASTNAME = upper(left(CONTACTLASTNAME,1)) || lower(substring(CONTACTLASTNAME,2,length(CONTACTLASTNAME))),
CONTACTFIRSTNAME = upper(left(CONTACTFIRSTNAME,1)) || lower(substring(CONTACTFIRSTNAME,2,length(CONTACTFIRSTNAME))) 
4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
  
alter table sales_dataset_rfm_prj
add column  QTR_ID varchar, 
add column MONTH_ID varchar, 
add column YEAR_ID varchar;
update sales_dataset_rfm_prj
set QTR_ID = extract(QUARTER from orderdate),
MONTH_ID = extract(MONTH from orderdate),
YEAR_ID = extract(YEAR from orderdate);
5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó
  
### boxplot
with cte as(
select Q1-1.5*IQR as min_value,
Q3-1.5*IQR as max_value
from (select percentile_cont(0.25) within group (order by quantityordered) as Q1,
percentile_cont(0.75) within group (order by quantityordered) as Q3,
percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as IQR
from sales_dataset_rfm_prj) as a)
select *
from public.sales_dataset_rfm_prj
where quantityordered < (select max_value from cte) and
quantityordered > (select min_value from cte)
dùng pp boxplot thì clean quá nhiều rows ở dataset từ hơn 2000 rows => 16 rows
### z_score
with cte as(
select *,(select avg(quantityordered) from public.sales_dataset_rfm_prj) as avg,
(select stddev(quantityordered) from public.sales_dataset_rfm_prj) as stddev
from public.sales_dataset_rfm_prj)
select *, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev)<=2
### có thể để z-score <=3 nếu muốn giữ lại nhiều dữ liệu hơn, nhưng cỡ mẫu hơn > 2000 đủ điều kiện để làm các loại phân tích kiểm định,
để z-score <=2 dữ liệu vẫn đảm bảo số lượng mẫu để thực hiện các kiểm định phân tích, lúc này mẫu đc lấy với đk chặt chẽ hơn, và 
đảm bảo cỡ mẫu > 2000 => lấy điều kiện z-score <=2, loại bỏ các giá trị > 2 và lưu ở table mới SALES_DATASET_RFM_PRJ_CLEAN
6.Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN

with cte as(
select *,(select avg(quantityordered) from public.sales_dataset_rfm_prj) as avg,
(select stddev(quantityordered) from public.sales_dataset_rfm_prj) as stddev
from public.sales_dataset_rfm_prj)

select *,(quantityordered-avg)/stddev as z_sroce
into SALES_DATASET_RFM_PRJ_CLEAN
from cte
where abs((quantityordered-avg)/stddev)<=2

