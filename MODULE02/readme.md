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

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/47674ce3-6d13-40f4-905c-49fafa9c43ed)

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/c12eb5ce-f893-46f6-8145-eb7504b8b336)

**Sales and profit per category**

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/cab64f1a-6e14-43e7-a355-b8303b4dd460)

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/d4ed3b59-1fcb-46e2-9b64-22d547f23497)

**Sales ratio per category**

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/c4a017a0-966b-46d8-a614-d98336efc40e)

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/5fc9d259-c5b2-49bf-aa0e-7f56853ef944)

**TOP 10 products by profit**

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/48016124-8bee-4299-91c5-0594f97d4f04)

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/83e509e9-9c72-4c64-a062-699decb68d7d)

**Lost profit by state**

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/c91b9c28-479e-46ca-a4be-d4b14236ac76)

![image](https://github.com/HannaStselmashok/DE-101/assets/99286647/f2b1cb07-5f29-4c80-bbbd-796f7dbbbc24)

[SQL queries](MODULE02/sql_queries.sql)
