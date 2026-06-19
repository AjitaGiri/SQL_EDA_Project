/*
Product Report

Purpose
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identiy High-Performers, Mid-Range, or Low-Performers.
3. Aggregate product-level metrics:
- total orders
- total sales
- total quantity sold
- lifespan(in months)
4. Calculate valuable KPIs:
- recency (months since last sale)
- average order revenue (AOR)
- average monthly revenue

*/

IF OBJECT_ID('gold.report_products','V') IS NOT NULL
DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

-- Base Query
with base_query as(
SELECT
d.product_key,
d.product_name,
s.customer_key,
s.order_number,
s.order_date,
d.category,
d.subcategory,
s.quantity,
d.cost,
s.sales_amount
FROM gold.fact_sales s
LEFT JOIN gold.dim_products d
ON s.product_key=d.product_key
WHERE s.order_date IS NOT NULL
),
products_aggregation as (
SELECT
product_key,
product_name,
category,
subcategory,
cost,
COUNT(DISTINCT order_number) AS total_orders,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount) AS total_sales,
SUM(quantity) as total_quantity,
MAX(order_date) as last_order_date,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY product_key,
product_name,
category,
subcategory,
cost
)
SELECT
product_key,
product_name,
category,
subcategory,
cost,
CASE
WHEN total_sales >50000 THEN 'High-Performers'
WHEN total_sales >= 10000 THEN 'Mid-Range'
ELSE 'Low_Performers'
END AS prdouct_segment,
-- calculate recency
DATEDIFF(MONTH, last_order_date,GETDATE()) AS recency,
lifespan,
total_orders,
total_quantity,
total_customers,
avg_selling_price,
-- Average Order Revenue 
CASE
WHEN total_orders=0 THEN 0
ELSE total_sales/total_orders
END AS avg_order_revenue,
-- Average Monthly Revenue
CASE
WHEN lifespan=0 THEN total_sales
ELSE total_sales/lifespan
END AS avg_monthly_revenue
FROM products_aggregation