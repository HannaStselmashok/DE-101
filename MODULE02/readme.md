# SuperStore project

## Data model
![data_model](https://github.com/HannaStselmashok/DE-101/assets/99286647/e6f53e59-d760-4e3a-ad02-29df1a61b5f2)
_Using [SqlDBM](https://sqldbm.com/Home/)_

## Analysing process (PostgreSQL)
### 1.1 Creating tables
I've [created tables](MODULE02/creating_tables.sql) based on the Data Model and loaded data using INSERT INTO SELECT.

### 1.2 SQL queries 

**Overview: Sales and profit per quarter**

```sql
select
    year,
    quarter,
    round(sum(sales), 1) as sales,
    round(sum(profit), 1) as profit
from
    calendar
inner join
    sales
    using(order_date)
group by
    year, quarter
order by
    year, quarter;
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/4d3e74ed-0414-4d79-b1a2-46b2fd03919e)

**Sales per month compared to the same month of the previous year**

```sql
select
    year,
    month,
    round(sum(sales), 1) as sales_per_month,
    round(lag(sum(sales), 12)
    over(
        order by year, month), 1) as sales_prev_year,
    round((sum(sales)/lag(sum(sales), 12)
    over(
        order by year, month)) * 100 - 100, 1) as percent_difference
from
    calendar
inner join
    sales
    using(order_date)
group by
    1, 2
order by
    1, 2
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/59c050b7-04f8-4360-85fb-8e183702b99d)

**Sales and profit per manager**

```sql
select
    year,
    person,
    round(sum(sales), 1) as sales,
    round(sum(profit), 1) as profit
from
    calendar
inner join
    geography
    using(geo_id)
inner join
    people
    using(region)
group by
    1, 2
order by
    1, 2
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/c12eb5ce-f893-46f6-8145-eb7504b8b336)

**Sales and profit per category**

```sql
select
    category,
    subcategory,
    round(sum(sales), 1) as sales,
    round(sum(profit), 1) as profit
from
    product
inner join
    sales
    using(product_id)
group by
    1, 2
order by
    1, 2, 3 desc
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/d4ed3b59-1fcb-46e2-9b64-22d547f23497)

**Sales ratio per category**

```sql
with category_sales as (
    select
        category,
        round(sum(sales), 1) as cat_sales
    from
        product
    inner join
        sales
        using(product_id)
    group by 1
)

select
    category,
    subcategory,
    round(sum(sales), 1) as sales,
    round(sum(sales)/cat_sales * 100, 1) as ratio_cat,
    cat_sales
from
    product
inner join
    sales
    using(product_id)
inner join
    category_sales
    using(category)
group by
    1, 2, 5
order by
    1, 3 desc
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/5fc9d259-c5b2-49bf-aa0e-7f56853ef944)

**TOP 10 products by profit**

```sql
select
    product_name,
    round(sum(profit), 1) as profit
from
    product
inner join
    sales
    using(product_id)
group by
    1
order by
    2 desc
limit 10
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/83e509e9-9c72-4c64-a062-699decb68d7d)

**Lost profit by state**

```sql
select
    state,
    round(sum(sales), 1) as refunds,
    count(returned) as amount_returned
from
    geography
inner join
    sales
    using(geo_id)
inner join
    (select
        distinct order_id,
        returned
    from
        returns) r
    using(order_id)
group by
    1
order by
    2 desc
```

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/f2b1cb07-5f29-4c80-bbbd-796f7dbbbc24)
