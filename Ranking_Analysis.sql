-- Rank [DIMENSION] BY [MEASURE] 

-- Which 5 products generate the highest revenue?

-- SIMPLE RANKING
SELECT TOP 5
p.product_id,
p.product_name,
SUM(s.sales_amount) as Total_Revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
on s.product_key=p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY Total_Revenue DESC;

-- Complex but flexibility, Ranking using window_functions
SELECT
*
FROM (
	SELECT
	p.product_id,
	p.product_name,
	SUM(s.sales_amount) as Total_Revenue,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) as rank_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	on s.product_key=p.product_key
	GROUP BY p.product_id,p.product_name
) AS ranked_products
where rank_revenue<=5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
p.product_id,
p.product_name,
SUM(s.sales_amount) as Total_Revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
on s.product_key=p.product_key
GROUP BY p.product_id,p.product_name
ORDER BY Total_Revenue;

-- Find the top 10 customers who have generated the highest revenue and 3 customers with fewest orders placed
SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) as Total_Revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
on s.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY Total_Revenue DESC;

SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT s.order_number) AS orders_placed
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
on s.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY orders_placed;

