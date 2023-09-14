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

--- Create Sales table
drop table sales;

CREATE TABLE sales
(
 sales_id    serial NOT NULL,
 order_id    varchar(15) NOT NULL,
 sales       numeric(9,4) NOT NULL,
 quantity    integer NOT NULL,
 discount    numeric(4,2) NOT NULL,
 profit      numeric(21,16) NOT NULL,
 order_date  date NOT NULL,
 shipping_id int NOT NULL,
 geo_id      int NOT NULL,
 product_id  int NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( sales_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( order_date ) REFERENCES calendar ( order_date ),
 CONSTRAINT FK_2 FOREIGN KEY ( shipping_id ) REFERENCES shipping ( shipping_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( geo_id ) REFERENCES geography ( geo_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( product_id ) REFERENCES product ( product_id )
);

CREATE INDEX FK_1 ON sales
(
 order_date
);

CREATE INDEX FK_2 ON sales
(
 shipping_id
);

CREATE INDEX FK_3 ON sales
(
 geo_id
);

CREATE INDEX FK_4 ON sales
(
 product_id
);

--- Fill Sales table
insert into sales(order_id, sales, quantity, discount, profit, order_date, shipping_id, geo_id, product_id)
select distinct o.order_id, o.sales, o.quantity, o.discount, o.profit, c.order_date, s.shipping_id, g.geo_id, p.product_id 
from orders o
inner join public.calendar c using(order_date)
inner join public.shipping s on o.ship_mode = s.shipping_mode
inner join public.geography g using(country, city, state, region, postal_code)
inner join public.product p using(category, subcategory, segment, product_name);

select *
from sales s 
limit 10;
