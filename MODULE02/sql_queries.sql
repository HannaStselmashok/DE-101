--- Overview: Sales and profit per quarter
select
year,
quarter,
round(sum(sales),1) as sales,
round(sum(profit),1) as profit
from calendar c inner join sales s using(order_date)
group by year, quarter 
order by year, quarter; 

--- Sales per month compared to the same month of the previous year
select
year,
month,
round(sum(sales), 1) as sales_per_month,
round(lag(sum(sales), 12) over (order by year, month), 1) as sales_prev_year,
round((sum(sales)/lag(sum(sales), 12) over (order by year, month)) * 100 - 100, 1) as percent_difference
from public.calendar c inner join public.sales s using(order_date)
group by year, month
order by year, month;

--- Sales and profit per manager
select
year,
person,
round(sum(sales),1) as sales,
round(sum(profit),1) as profit
from calendar c inner join sales s using(order_date)
inner join geography g using(geo_id)
inner join people p using(region)
group by year, person
order by year, person;

--- Sales and profit per category
select 
category,
subcategory,
round(sum(sales),1) as sales,
round(sum(profit),1) as profit
from product p inner join sales s using(product_id)
group by category, subcategory 
order by category, subcategory, sales desc;

--- Sales ratio per category
with category_sales as
(select
category,
round(SUM(sales),1) as cat_sales
from product p inner join sales s using(product_id)
group by category)

select 
category,
subcategory,
round(sum(sales), 1) as sales,
round(sum(sales)/cat_sales * 100, 1) as ratio_cat,
cat_sales
from product p inner join sales s using(product_id)
inner join category_sales cs using(category)
group by category, subcategory, cat_sales
order by category, sales desc;

--- TOP 10 products by profit
select 
product_name,
round(sum(profit),1) as profit
from product p inner join sales s using(product_id)
group by product_name 
order by profit desc 
limit 10;

--- Lost profit by state
select 
state,
round(sum(sales),1) as refunds,
count(returned) as amount_returned
from geography g inner join sales s using(geo_id)
inner join
(select distinct order_id,
returned
from returns) r
using(order_id)
group by state 
order by refunds desc;