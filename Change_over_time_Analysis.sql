/*
Change over Time Analysis

Purpose:
- To track trends, growth, and changes in key metrics over time.
- For time-series analysis and identifying seasonality
- To measure growth or decline over specific periods

SQL function used:
- Date Functions: DATEPART(),DATETRUNC(), FORMAT()
- Aggregare Functions: SUM(), COUNT(), AVG()

*/

-- Analyse sales performance over time
SELECT
YEAR(order_date) as year,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)	

-- DATETRUNC()
SELECT
DATETRUNC(month,order_date) as order_date,
SUM(sales_amount) as total_sales,
COUNT(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)
