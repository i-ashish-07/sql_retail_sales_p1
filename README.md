
# 📊 SQL Retail Sales Analysis – Project 1

## 📌 Project Overview
This project demonstrates **retail sales data analysis using SQL**.  
The dataset contains transactional-level sales data with details such as customer demographics, product categories, transaction time, and sales values.  

The goal of this project is to perform **data cleaning, exploration, and business analysis** using SQL queries.

---
## 🎯Objectives
1) Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2) Data Cleaning: Identify and remove any records with missing or null values.
3) Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4) Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
   
## 🗂️ Dataset Structure
The project creates a table named **`sales`** with the following columns:

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

## 🔧 Data Cleaning
1. Identify missing or null values.  
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

## 📊 Data Exploration
- **Total number of sales**  
- **Unique customers**  
- **Unique categories**  

```sql
SELECT COUNT(*) AS total_sales FROM sales;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;
SELECT COUNT(DISTINCT category) AS unique_categories FROM sales;
```

✅ **Sample Output:**

| total_sales | unique_customers | unique_categories |
|-------------|------------------|-------------------|
| 15,430      | 2,130            | 6                 |

---

## 🧩 Business Analysis – Key Questions

### Q1. Retrieve all sales made on `2022-11-05`
```sql
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';
```

✅ **Sample Output:**

| transaction_id | sale_date  | sale_time | customer_id | category   | quantity | total_sale |
|----------------|------------|-----------|-------------|------------|----------|------------|
| 10023          | 2022-11-05 | 10:32:00  | 501         | Clothing   | 3        | 1500       |
| 10024          | 2022-11-05 | 14:45:00  | 876         | Electronics| 1        | 2200       |

---

### Q2. Clothing transactions (quantity > 4) in Nov 2022
```sql
SELECT * FROM sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;
```

✅ **Sample Output:**

| transaction_id | sale_date  | customer_id | category | quantity | total_sale |
|----------------|------------|-------------|----------|----------|------------|
| 10045          | 2022-11-12 | 722         | Clothing | 6        | 2400       |
| 10077          | 2022-11-28 | 941         | Clothing | 5        | 2000       |

---

### Q3. Total sales by category
```sql
SELECT category, SUM(total_sale) AS total_sales
FROM sales
GROUP BY category;
```

✅ **Sample Output:**

| category     | total_sales |
|--------------|-------------|
| Clothing     | 3,25,000    |
| Electronics  | 5,40,000    |
| Beauty       | 1,45,000    |
| Home & Decor | 2,10,000    |

---

### Q4. Average age of Beauty category customers
```sql
SELECT FLOOR(AVG(age)) AS avg_age
FROM sales
WHERE category = 'Beauty';
```

✅ **Sample Output:**

| avg_age |
|---------|
| 29      |

---

### Q5. Transactions with total_sale > 1000
```sql
SELECT * FROM sales
WHERE total_sale > 1000;
```

✅ **Sample Output:**

| transaction_id | customer_id | category   | total_sale |
|----------------|-------------|------------|------------|
| 10088          | 633         | Clothing   | 1800       |
| 10112          | 821         | Electronics| 2500       |

---

### Q6. Transactions by gender in each category
```sql
SELECT gender, category, COUNT(transaction_id) AS total_transactions
FROM sales
GROUP BY gender, category
ORDER BY category;
```

✅ **Sample Output:**

| gender | category    | total_transactions |
|--------|-------------|--------------------|
| Male   | Clothing    | 1,240              |
| Female | Clothing    | 1,350              |
| Male   | Electronics | 980                |
| Female | Electronics | 1,050              |

---

### Q7. Best-selling month per year
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

✅ **Sample Output:**

| year | month | avg_sale | rank |
|------|-------|----------|------|
| 2022 | 11    | 820.55   | 1    |
| 2023 | 07    | 910.75   | 1    |

---

### Q8. Top 5 customers by total sales
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

✅ **Sample Output:**

| customer_id | total_sales |
|-------------|-------------|
| 876         | 22,500      |
| 502         | 18,300      |
| 941         | 16,750      |
| 101         | 14,200      |
| 350         | 13,800      |

---

### Q9. Unique customers per category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY category;
```

✅ **Sample Output:**

| category     | unique_customers |
|--------------|------------------|
| Clothing     | 750              |
| Electronics  | 560              |
| Beauty       | 420              |

---

### Q10. Orders by shift
```sql
WITH shifts AS (
  SELECT *,
         CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
         END AS shift
  FROM sales
)
SELECT shift, COUNT(*) AS total_orders
FROM shifts
GROUP BY shift;
```

✅ **Sample Output:**

| shift     | total_orders |
|-----------|--------------|
| Morning   | 5,300        |
| Afternoon | 6,100        |
| Evening   | 4,030        |

---

## 🔎 Findings

* **Electronics and Clothing** are the top revenue-generating categories.
* **Afternoon shift (12–17 hrs)** records the highest number of sales, followed by Evening.
* **November 2022** stands out as the best-performing month due to seasonal demand.
* A small group of **loyal customers** contributes disproportionately to total sales.

---

## 📑 Reports

* **Category Sales Report** → Revenue comparison across categories.
* **Shift Performance Report** → Sales distribution by Morning, Afternoon, and Evening.
* **Monthly Sales Report** → Identified November as the peak sales month.
* **Customer Loyalty Report** → Highlighted top 5 customers driving high sales.

---

## 🎯 Conclusion

The sales analysis shows that business growth is primarily driven by Electronics and Clothing, with younger customers contributing strongly to Beauty category sales. Afternoon hours and the holiday season present significant sales opportunities, making them crucial for planning promotions and resource allocation. Additionally, a small set of loyal, high-value customers plays a major role in overall revenue, which highlights the importance of customer retention strategies. Focusing on these insights can help optimize operations, improve customer engagement, and maximize profitability.

---
💡 Business Recommendations

* Focus on high-performing categories → Increase inventory and targeted promotions for Electronics and Clothing, as they generate the most revenue.
* Optimize operations during peak hours → Allocate more staff and resources in the Afternoon and Evening shifts to handle higher sales volumes efficiently.
* Leverage customer loyalty → Introduce loyalty programs or personalized offers for top customers who drive a significant share of sales.
---
*END OF PROJECT**

