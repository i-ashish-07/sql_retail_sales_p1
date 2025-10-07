
# 📊 SQL Retail Sales Analysis – Project 1

## 📌 Project Overview
This project demonstrates **retail sales data analysis using SQL**.  
The dataset contains transactional-level sales data with details such as customer demographics, product categories, transaction time, and sales values.  

The goal of this project is to perform **data cleaning, exploration, and business analysis** using SQL queries.

---
##  Objectives
1) Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2) Data Cleaning: Identify and remove any records with missing or null values.
3) Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4) Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
   
##  Dataset Structure
The project creates a table named **`sales_analysis`** with the following columns:

| Column           | Description |
|------------------|-------------|
| `transaction_id` | Unique ID for each transaction |
| `sale_date`      | Date of the transaction |
| `sale_time`      | Time of the transaction |
| `customer_id`    | Unique customer ID |
| `gender`         | Gender of the customer |
| `age`            | Age of the customer |
| `category`       | Product category (Clothing, Beauty, Electronics, etc.) |
| `quantity`       | Quantity of items purchased |
| `price_per_unit` | Price per unit item |
| `cogs`           | Cost of goods sold |
| `total_sale`     | Total sale value |

---

## First, we will create a Table Schema
```sql
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
```
## Then, import the CSV file into SQL, ensuring the table headings are correctly ordered.

  Next, we will confirm the data import and review the entire table.

```sql

select * from sales_analysis
```

---
## Create a duplicate of the original data for safety before starting the data cleaning process.

- CREATE TABLE sales (LIKE sales_analysis INCLUDING ALL); → creates a new table sales with the same schema/structure (columns, data types, constraints, indexes) as sales_analysis.

- INSERT INTO sales SELECT * FROM sales_analysis; → copies all the data from sales_analysis into the new sales table.

 Together, these two steps make a full duplicate (structure + data) of the original table.

``` sql
create table sales
(like sales_analysis including all);

insert into sales
select * from sales_analysis;
```
---
##  Data Cleaning
1. Identify missing or null values.

``` sql
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
```

---

2. Delete incomplete rows to ensure accuracy.  

```sql
DELETE FROM sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

---

##  Data Exploration
- **Total number of sales**  
- **Unique customers**  
- **Unique categories**  

```sql
SELECT COUNT(*) AS total_sales FROM sales;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;
SELECT COUNT(DISTINCT category) AS unique_categories FROM sales;
```

 **Sample Output:**

| total_sales | unique_customers | unique_categories |
|-------------|------------------|-------------------|
| 15,430      | 2,130            | 6                 |

---

##  Business Analysis – Key Questions

### Q1. Write a SQL query to retrieve all columns for sales made on 2022-11-05.

```sql
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';
```

 **Sample Output:**

| transaction_id | sale_date  | sale_time | customer_id | category   | quantity | total_sale |
|----------------|------------|-----------|-------------|------------|----------|------------|
| 10023          | 2022-11-05 | 10:32:00  | 501         | Clothing   | 3        | 1500       |
| 10024          | 2022-11-05 | 14:45:00  | 876         | Electronics| 1        | 2200       |

---

### Q2. Write a SQL query to retrieve all Transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

```sql
SELECT * FROM sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

 **Sample Output:**

| transaction_id | sale_date  | customer_id | category | quantity | total_sale |
|----------------|------------|-------------|----------|----------|------------|
| 10045          | 2022-11-12 | 722         | Clothing | 6        | 2400       |
| 10077          | 2022-11-28 | 941         | Clothing | 5        | 2000       |

---

### Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

```sql
SELECT category, SUM(total_sale) AS total_sales
FROM sales
GROUP BY category;
```

 **Sample Output:**

| category     | total_sales |
|--------------|-------------|
| Clothing     | 3,25,000    |
| Electronics  | 5,40,000    |
| Beauty       | 1,45,000    |
| Home & Decor | 2,10,000    |

---

### Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

```sql
SELECT FLOOR(AVG(age)) AS avg_age , category
FROM sales
WHERE category = 'Beauty'
Group by category;
```

 **Sample Output:**

| avg_age | category
|---------|---------|
| 29      | Beauty  |

---

### Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
```sql
SELECT * FROM sales
WHERE total_sale > 1000;
```

 **Sample Output:**

| transaction_id | customer_id | category   | total_sale |
|----------------|-------------|------------|------------|
| 10088          | 633         | Clothing   | 1800       |
| 10112          | 821         | Electronics| 2500       |

---

### Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

```sql
SELECT gender, category, COUNT(transaction_id) AS total_transactions
FROM sales
GROUP BY gender, category
ORDER BY category;
```

 **Sample Output:**

| gender | category    | total_transactions |
|--------|-------------|--------------------|
| Male   | Clothing    | 1,240              |
| Female | Clothing    | 1,350              |
| Male   | Electronics | 980                |
| Female | Electronics | 1,050              |

---

### Q7. Write a SQL query to calculate the average sale for each month. Also, find out the best-selling month in each year.

```sql
WITH monthly_avg AS (
  SELECT 
      EXTRACT(YEAR FROM sale_date) AS year,
      EXTRACT(MONTH FROM sale_date) AS month,
      ROUND(AVG(total_sale), 2) AS avg_sale,
      RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
                   ORDER BY AVG(total_sale) DESC) AS rank
  FROM sales
  GROUP BY year, month
)
SELECT * FROM monthly_avg WHERE rank = 1;
```

 **Sample Output:**

| year | month | avg_sale | rank |
|------|-------|----------|------|
| 2022 | 11    | 820.55   | 1    |
| 2023 | 07    | 910.75   | 1    |

---

### Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

 **Sample Output:**

| customer_id | total_sales |
|-------------|-------------|
| 876         | 22,500      |
| 502         | 18,300      |
| 941         | 16,750      |
| 101         | 14,200      |
| 350         | 13,800      |

---

### Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY category;
```

 **Sample Output:**

| category     | unique_customers |
|--------------|------------------|
| Clothing     | 750              |
| Electronics  | 560              |
| Beauty       | 420              |

---

### Q10. Write a SQL query to create each shift and count the number of orders.
Example shifts: Morning: < 12 Afternoon: BETWEEN 12 AND 17 Evening: > 17
```sql
WITH hours AS (
  SELECT *,
         CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
         END AS shift
  FROM sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hours
GROUP BY shift;
```

 **Sample Output:**

| shift     | total_orders |
|-----------|--------------|
| Morning   | 5,300        |
| Afternoon | 6,100        |
| Evening   | 4,030        |

---

##  Findings

* **Electronics and Clothing** are the top revenue-generating categories.
* **Afternoon shift (12–17 hrs)** records the highest number of sales, followed by Evening.
* **November 2022** stands out as the best-performing month due to seasonal demand.
* A small group of **loyal customers** contributes disproportionately to total sales.

---

##  Reports

* **Category Sales Report** → Revenue comparison across categories.
* **Shift Performance Report** → Sales distribution by Morning, Afternoon, and Evening.
* **Monthly Sales Report** → Identified November as the peak sales month.
* **Customer Loyalty Report** → Highlighted top 5 customers driving high sales.

---

##  Conclusion

The sales analysis shows that business growth is primarily driven by Electronics and Clothing, with younger customers contributing strongly to Beauty category sales. Afternoon hours and the holiday season present significant sales opportunities, making them crucial for planning promotions and resource allocation. Additionally, a small set of loyal, high-value customers plays a major role in overall revenue, which highlights the importance of customer retention strategies. Focusing on these insights can help optimize operations, improve customer engagement, and maximize profitability.

---

*END OF PROJECT**

