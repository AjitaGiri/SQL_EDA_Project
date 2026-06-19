/*
Customer Report

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend

*/

WITH base_query AS
(
-- Base Query: Retrives core columns from tables
SELECT
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS Customer_Name,
DATEDIFF(year,c.birthdate,GETDATE()) AS Age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key=c.customer_key
WHERE s.order_date IS NOT NULL
)
, customer_aggregation AS(
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	MAX(order_date) as last_order_date,
	COUNT(DISTINCT product_key) AS total_products,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS customer_span
	FROM base_query 
	GROUP BY
	customer_key,
	customer_number,
	customer_name,
	age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE
WHEN age<20 THEN 'Under 20'
WHEN age between 20 and 29 THEN '20-29'
WHEN age between 30 and 39 THEN '30-30'
WHEN age between 40 and 49 THEN '40-49'
ELSE '50 and above'
END AS age_group,
CASE
WHEN customer_span>=12 and total_sales>5000 THEN 'VIP'
WHEN customer_span>=12 and total_sales <=5000 THEN 'Regular'
ELSE 'New'
END AS customer_segment,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,
total_orders,
total_sales,
total_products,
total_quantity,
customer_span,
-- Compute average order value (AVO)
CASE WHEN total_sales=0 THEN 0
ELSE total_sales/total_orders
END AS avg_order_value,
-- Compute average monthly spend
CASE WHEN customer_span =0 THEN total_sales
ELSE TOTAL_SALES/total_orders
END AS avg_monthly_spend
FROM customer_aggregation
