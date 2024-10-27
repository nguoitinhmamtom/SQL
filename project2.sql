1. 
select 
FORMAT_DATE('%Y-%m', created_at) as month_year,
sum(user_id) as total_user,
sum(order_id) as total_order,
from bigquery-public-data.thelook_ecommerce.orders 
where FORMAT_DATE('%Y-%m', created_at) between '2019-01'and'2022-04' and status <> 'Cancelled'
group by 1
/*
Dữ liệu được lấy từ t1 2019 đến t4 2022, có sự tăng trưởng ở số lượng đơn hàng và số lượng người dùng. 
Nhận thấy người dùng có xu hướng mua hàng online ngày càng tăng, dữ liệu từ năm 2019 sang đến năm 2020 cho thấy sự bùng nổ về 
cả hai chỉ số người dùng và lượng đơn hàng do ảnh hưởng từ đại dịch Covid khiến người ta cảm thấy ''sợ hãi'' khu bước ra đường, 
cộng với bùng nổ xu hướng startup thời trang online dẫn đến tăng trưởng vượt bậc cho doanh nghiệp. Sau một thời gian dài ảnh hưởng 
của đại dịch Covid cùng với sự xuất hiện của work from home hay là hybrid working làm cho mua hàng thời trang online nói riêng và 
mua hàng online nói chung càng phát triển mạnh mẽ, trở thành thói quen tiêu dùng của khách hàng. Nhìn chung, cả hai chỉ số đều tăng 
nhưng xét trong năm ta nhận thấy có xu hướng tăng mua vào các tháng cuối năm vì do lễ tết và mùa du lịch.
*/
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
/*
số người dùng qua các năm có sự tăng mạnh, điều này là do trong các năm này diễn ra đại dịch Covid dần hình thành thói quen tiêu dùng, 
giá trị đơn hàng tb lại ko thay đổi quá nhiều qua các năm.
  
năm 2019, thời điểm này dịch chưa cao điểm, người dùng chưa chấp nhận hình thức mua hàng trực tuyến nhiều, nên lượng user ko cao, 
dù cho lượng user có tăng đáng kể nhưng giá trị đơn hàng tb ko thay đổi có thể phần lớn đơn hàng do khách cũ, khách quen trước đó duy trì. 
Mục tiêu của DN là kéo them new_user và giữ chân loyalty_customer bằng cách tung khuyến mãi deal hời, voucher chất lượng.
  
năm 2020, thời điểm dịch Covid căng thẳng nhất, lượng người dùng có tăng chứng tỏ người dùng đã chú ý đến việc mua sắm online và 
đang dần hình thành thói quen mua sắm của họ, tuy nhiên lượng user tăng giá trị đơn hàng tb giảm, chứng tỏ dịch vụ hoặc sản phẩm của 
sàn thương mại ko đáp ứng tốt mong muốn của người dùng. Các vấn đề mà DN phải lưu ý là trải nghiệm người dùng đối với sàn tmại là có tốt 
hay không (gaio diện thân thiện dễ dùng, các bước thanh toán đơn giản, pp thanh toán đa dạng, ...), chất lượng sản phẩm trên sàn chưa đủ 
chất lượng để tại uy tín trong lòng người dùng. Ngoài ra, DN đang phải cạnh tranh với làn sóng startup về mảng kinh doanh thời trang online 
hay là các sàn tmại điện tử khác.

năm 2021, trừ những tháng đầu của năm còn chịu ảnh hưởng nặng nề từ covid thì hầu hết thánh tiếp theo tình hình dịch đã có thể kiểm soát 
được, lượng người dùng trên sàn tmại tăng cao => người dùng đã hình thành thói quen mua sắm online, trở thành hình thức mua sắm thường 
xuyên của họ, nhưng giá trị tb của đơn hàng tăng nhẹ ko đáng kể, ngoài những vấn để cần phải cải thiện dịch vụ lúc này DN phải cạnh tranh 
với hàng loạt các sàn tmại khác.

dù lấy dữ liệu của 4 tháng đầu năm 2022, nhưng ghi nhận lượng người dùng tăng cao, giá trị tb đơn hàng các tháng đầu năm cao, và 
sắp bước vào đợt cao điểm du lịch làm tăng cầu mua sắm, DN phải có điều chỉnh phù hợp về giá, khuyến mãi để thu hút người mua và 
lượng đơn hàng. Dù DN đang phải đối mặt với nhiều đối thủ cạnh tranh cả về giá lẫn uy tín, song lượng user và giá trị đơn hàng tb 
có tăng vẫn là dấu hiệu tốt cho thấy sự phát triển đvs DN. (vì chưa có dữ liệu thị trường để xem quy mô thị trường cỡ nào và mình chiếm 
thị phần ra sao nên chưa đánh giá toàn cảnh được)
*/
3. 
WITH table1 as 
(SELECT first_name,last_name, gender, 
CASE
  WHEN age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'F' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04') THEN 'oldest'
  WHEN age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'F' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04') THEN 'youngest'
  ELSE CAST(age AS STRING)
END age 
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'F' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'),
table2 as 
(SELECT first_name,last_name, gender, 
CASE
  WHEN age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'M' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04') THEN 'oldest'
  WHEN age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'M' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04') THEN 'youngest'
  ELSE CAST(age AS STRING)
END age 
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'M' AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
SELECT * FROM table1
UNION ALL
SELECT * FROM table2
/*
khách nữ có độ tuổi trẻ nhất là 12 và số lượng là 470,lớn nhất là 70 và số lượng là 445 trên 27993 khách nữ
khách nam có độ tuổi trẻ nhất là 12 và số lượng là 448,lớn nhất là 70 và số lượng là 464 trên 27855 khách nam
-> xu hướng mua hàng trực tuyến lan đến khách hàng có độ tuổi vị thành niên và nhóm lớn tuổi, xu hướng được nhiều lứa tuổi yêu thích và được 
thị trường chấp nhận, dù bình thường khách hàng mục tiêu mà các sàn tmđt hướng tới là người trẻ, tuy nhiên khách hàng có độ tuổi trải dài như vậy tạo
ra một thị trường mới, có thể là một danh mục mới, thậm chí là phát triển một sàn tmđt mới dành riêng cbo khách hàng có nhóm tuổi như trên.
*/
4.
with cte as (select a.*, format_date('%Y-%m', a.created_at) as month_year
,b.cost,b.name as product_name
from bigquery-public-data.thelook_ecommerce.order_items a
join bigquery-public-data.thelook_ecommerce.products b
on a.product_id=b.id),
cte1 as (select month_year, product_id, product_name, sale_price as sale, cost, sum(sale_price) - sum(cost) as profit
from cte
group by month_year, product_id, product_name, sale_price,cost)
select * from (select *, dense_rank() over(partition by month_year order by profit desc) as rank_per_month from cte1) as a
where rank_per_month <= 5
order by month_year
https://docs.google.com/spreadsheets/d/1_l0GUawirlfubumpRY83oyjUB6LxRr218sgM646i8ic/edit?usp=sharing
