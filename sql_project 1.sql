drop table if exists sales_analysis;
create table sales_analysis (
				transaction_id	int primary key,
				sale_date date,
				sale_time time,
				customer_id	 int,
				gender varchar(50),
				age	int,
				category varchar(50),	
				quantity int,	
				price_per_unit float,
				cogs float,
				total_sale int
);

select * from sales_analysis;

create table sales
(like sales_analysis including all);

insert into sales
select * from sales_analysis;

select * from sales;

--data cleaning

select * from sales
where transaction_id is null or 
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or 
category is null or 
quantity is null or 
price_per_unit is null or 
cogs is null or 
total_sale is null;

-- delete the rows

delete from sales
where transaction_id is null or 
sale_date is null or
sale_time is null or
customer_id is null or
gender is null or 
category is null or 
quantity is null or 
price_per_unit is null or 
cogs is null or 
total_sale is null;

--data exploration
--how many sales we have

select count(*) from sales;

-- how many unique customer we have 

select count(distinct customer_id) from sales;

-- how many unique category we have

select count(distinct category) from sales;

select * from sales;

-- business key problems and answers

-- Q1. Write a SQL query to retrieve all columns for sales made on 2022-11-05.

select * from sales 
where sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--the quantity sold is more than 4 in the month of Nov-2022.

select * from sales
where category = 'Clothing'
and TO_CHAR(sale_date , 'YYYY-MM')= '2022-11'
AND quantity >=4;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

select * from sales;

select sum(total_sale)as total,category, count(*) from sales
group by category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select * from sales;

select floor(avg(age))as avg_age , category from sales
where category = 'Beauty'
group by category;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from sales

 select * from sales 
 where total_sale= 1000;


-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(transaction_id) , gender , category from sales
group by gender , category
order by category;

-- Q7. Write a SQL query to calculate the average sale for each month.
-- Also, find out the best-selling month in each year.

select * from sales;

with t1 as
(
SELECT 
    ROUND(AVG(total_sale), 2) AS avg_sale,
    EXTRACT(MONTH FROM sale_date) AS month,
    EXTRACT(YEAR FROM sale_date) AS year,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
        ORDER BY AVG(total_sale) DESC
    ) AS rank
FROM sales
GROUP BY year, month
ORDER BY year, avg_sale DESC
)
select * from t1
where rank = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

select * from sales;

select sum(total_sale) as sales , customer_id from sales
group by customer_id 
order by sales desc
limit 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

select * from sales;
select count(distinct customer_id)as unique_customer , category from sales
group by category;


-- Q10. Write a SQL query to create each shift and count the number of orders.
-- Example shifts: Morning: <= 12 Afternoon: BETWEEN 12 AND 17 Evening: > 17

select * from sales;

with hours as
(
   select *,
       case 
	      when extract(hour from sale_time) <= 12 then 'Morning'
		  when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		  else 'Evening'
       end as shift
   from sales
)
select shift,
            count(*) as total_sales  from hours
group by shift;










