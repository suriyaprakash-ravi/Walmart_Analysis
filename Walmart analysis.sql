create database walmartsales;
use walmartsales;

-- -----------------------------------------------------------------------------------------------------
-- ---------------Feature engineering--------------------------------------------------------------------
-- Creating time of the day 
select time,
	(case
    when `time` between "00:00:00" and "12:00:00" then "Morning"
    when `time` between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
    end ) as time_of_date from walmart_table;
alter table walmart_table add column time_of_date varchar(15);
update walmart_table
set time_of_date = (case
    when `time` between "00:00:00" and "12:00:00" then "Morning"
    when `time` between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
    end );
    select * from walmart_table;
    
-- Creating month name
select date,monthname(date) from walmart_table;

alter table walmart_table add column month_name varchar(10);
update walmart_table
set month_name = monthname(date);
    
-- creating day_name
select date,dayname(date) from walmart_table;
alter table walmart_table add column day_name varchar(15);
update walmart_table
set day_name = dayname(date);

-- ---------------------------------------------------------------------------------------------------
-- -----------------Generic questions-----------------------------------------------------------------

-- How many unique cities does the data have?
select distinct(city) from walmart_table;

-- How many unique branches does the data have?
select distinct (branch) from walmart_table;

-- unique cities with their branches
select distinct city,branch from walmart_table;
-- ---------------------------------------------------------------------------------------------------
-- ------------------------- Product questions -------------------------------------------------------
-- How many unique product lines does the data have?
select distinct(`product line`) from walmart_table;

-- What is the most common payment method?
select payment,count(payment) as cnt from walmart_table 
group by payment order by cnt desc ;

-- What is the most selling product line?
select `product line`,count(`product line`) as product_line from walmart_table
group by `product line` order by Product_line desc;

-- What is the total revenue by month?
select month_name,sum(total) as total_revenue from walmart_table
group by month_name order by total_revenue desc;

-- What product line had the largest revenue?
select `product line`, sum(total) as total_revenue
from walmart_table group by `product line` order by total_revenue desc;

-- What is the city with the largest revenue?
select city, branch,sum(total) as total_revenue from walmart_table
group by city, branch order by total_revenue desc;

-- What product line had the largest VAT?
select `product line`,max(`tax 5%`) as vat from walmart_table
group by `product line` order by vat desc;

-- Which branch sold more products than average product sold?
select branch,sum(quantity) as qnty
from  walmart_table group by branch
having sum(quantity) > (select avg(quantity) from walmart_table);

-- What is the most common product line by gender?
select gender,`product line`,count(gender) as gen from walmart_table
group by gender, `product line` order by gen desc;

-- What is the average rating of each product line?
select `product line`,avg(rating) as rat from walmart_table
group by `product line` order by rat desc; 

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) from walmart_table;

select `product line`, case when avg(quantity) > 5.51 then "Good"
else "Bad" end as remark from walmart_table
group by `product line`;

-- ---------------------------------------------------------------------------------------------------
-- ----------------------------Sales-----------------------------------------------------------------
-- Number of sales made in each time of the day per weekday
select time_of_date, count(*) from walmart_table
group by time_of_date;

-- Which of the customer types brings the most revenue?
select `customer type`,sum(total) from walmart_table
group by `customer type`;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, sum(`tax 5%`) as vat from walmart_table
group by city order by vat desc;

-- Which customer type pays the most in VAT?
select `customer type`, sum(`tax 5%`) as vat from walmart_table
group by `customer type` order by vat desc;
-- ----------------------------------------------------------------------------------------------------
-- --------------------Customer---------------------------------------------------------------------------
-- How many unique customer types does the data have?
select distinct `customer type` from walmart_table;

-- How many unique payment methods does the data have?
select distinct payment from walmart_table;

-- What is the most common customer type?
select `customer type`,count(`customer type`) as cnt from walmart_table
group by `customer type` order by cnt desc;

-- What is the gender of most of the customers?
select gender, count(gender) as gen from walmart_table
group by gender order by gen;

-- What is the gender distribution per branch?
select branch,count(gender) as gen from walmart_table
group by branch order by gen;

-- Which time of the day do customers give most ratings?
select time_of_date,avg(rating) from walmart_table
group by time_of_date;

-- Which time of the day do customers give most ratings per branch?
select branch,sum(rating) from walmart_table
group by branch;

-- Which day for the week has the best avg ratings?
select day_name,avg(rating) as rat from walmart_table
group by day_name order by rat desc;

-- Which day of the week has the best average ratings per branch?
select branch,day_name,avg(rating) as rat from walmart_table
group by day_name,branch order by rat desc;



