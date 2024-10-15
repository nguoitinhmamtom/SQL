1. alter table sales_dataset_rfm_prj
alter column ordernumber type int using(trim(ordernumber) :: int),
alter column quantityordered type int using(trim(quantityordered) :: int),
alter column priceeach type numeric using(trim(priceeach) :: numeric),
alter column orderlinenumber type int using(trim(orderlinenumber) :: int),
alter column sales type numeric using(trim(sales) :: numeric),
alter column msrp type int using(trim(msrp) :: int);
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date);
2.
select ORDERNUMBER from sales_dataset_rfm_prj order by ORDERNUMBER;
select QUANTITYORDERED from sales_dataset_rfm_prj order by QUANTITYORDERED;
select PRICEEACH from sales_dataset_rfm_prj order by PRICEEACH;
select ORDERLINENUMBER from sales_dataset_rfm_prj order by ORDERLINENUMBER;
select SALES from sales_dataset_rfm_prj order by SALES;
select ORDERDATE from sales_dataset_rfm_prj order by ORDERDATE;
3.
alter table sales_dataset_rfm_prj
add column  CONTACTLASTNAME varchar, 
add column CONTACTFIRSTNAME varchar, 
update sales_dataset_rfm_prj
set CONTACTLASTNAME = right(CONTACTFULLNAME, length(CONTACTFULLNAME) - position('-' in CONTACTFULLNAME)),
CONTACTFIRSTNAME = substring(CONTACTFULLNAME,1,position('-' in CONTACTFULLNAME)-1)
update sales_dataset_rfm_prj
set CONTACTLASTNAME = upper(left(CONTACTLASTNAME,1)) || lower(substring(CONTACTLASTNAME,2,length(CONTACTLASTNAME))),
CONTACTFIRSTNAME = upper(left(CONTACTFIRSTNAME,1)) || lower(substring(CONTACTFIRSTNAME,2,length(CONTACTFIRSTNAME))) 
4. 
alter table sales_dataset_rfm_prj
add column  QTR_ID varchar, 
add column MONTH_ID varchar, 
add column YEAR_ID varchar;
update sales_dataset_rfm_prj
set QTR_ID = extract(QUARTER from orderdate),
MONTH_ID = extract(MONTH from orderdate),
YEAR_ID = extract(YEAR from orderdate);
