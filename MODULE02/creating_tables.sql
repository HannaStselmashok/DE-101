--- Create Geography table
drop table geography;

CREATE TABLE geography
(
 geo_id      serial NOT NULL,
 country     varchar(15) NOT NULL,
 city        varchar(20) NOT NULL,
 state       varchar(25) NOT NULL,
 region      varchar(10) NOT NULL,
 postal_code integer,
 CONSTRAINT PK_1 PRIMARY KEY ( geo_id )
);

--- Fill Geography table

insert into public.geography (country, city, state, region, postal_code)
select distinct country, city, state, region, postal_code
from public.orders;

select *
from public.geography g 
limit 10;

--- Create Product table
drop table product;

CREATE TABLE product
(
 product_id   serial NOT NULL,
 category     varchar(20) NOT NULL,
 subcategory  varchar(20) NOT NULL,
 segment      varchar(20) NOT NULL,
 product_name varchar(150) NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( product_id )
);

--- Fill Product table
insert into public.product (category, subcategory, segment, product_name)
select distinct category, subcategory, segment, product_name 
from public.orders;

select *
from public.product
limit 10;

--- Create Shipping table
drop table shipping;

CREATE TABLE shipping
(
 shipping_id   serial NOT NULL,
 shipping_mode varchar(20) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( shipping_id )
);

--- Fill Shipping table
insert into shipping (shipping_mode)
select distinct ship_mode
from public.orders;

--- Create Calendare table
drop table calendar;

CREATE TABLE calendar
(
 order_date date NOT NULL,
 year       integer NOT NULL,
 quarter    varchar(5) NOT NULL,
 month      integer NOT NULL,
 week       integer NOT NULL,
 month_day   integer NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( order_date )
);

--- Fill Calendar table
insert into calendar (order_date, year, quarter, month, week, month_day)
select 
distinct order_date,
extract (year from order_date),
concat ('Q', extract (quarter from order_date)),
extract (month from order_date),
extract (week from order_date),
extract (day from order_date)
from public.orders;

select *
from calendar 
limit 10;