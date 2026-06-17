-- DATA SEGMENTATION ANALYSIS

/*Segment products into cost ranges and 
count how many products fall into each segment*/
WITH cost_ranges AS (
SELECT
product_key,
product_name,
CASE
WHEN cost <100 THEN 'BELOW 100'
WHEN cost BETWEEN 100 AND 500 THEN '100-500'
WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
ELSE 'LOW'
END as segment
FROM gold.dim_products
)
SELECT
segment,
COUNT(product_key) as total_products
FROM cost_ranges
GROUP BY segment
ORDER BY total_products DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH SPENDING_BEHAVIOR AS(
SELECT
c.customer_key,
MIN(s.order_date) as first_order,
MAX(s.order_date) as last_order,
DATEDIFF(MONTH,MIN(s.order_date),MAX(s.order_date)) AS SPAN,
SUM(s.sales_amount) AS TOTAL_SPENDING
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales s
ON c.customer_key=s.customer_key
GROUP BY c.customer_key
)
SELECT
SEGMENT,
COUNT(customer_key) AS TOTAL_CUSTOMERS
FROM (
		SELECT
		customer_key,
		CASE
		WHEN SPAN>=12 AND TOTAL_SPENDING >5000 THEN 'VIP'
		WHEN SPAN>=12 AND TOTAL_SPENDING <=5000 THEN 'REGULAR'
		ELSE 'NEW'
		END AS SEGMENT
		FROM SPENDING_BEHAVIOR
		) AS SEGMENTED_CUSTOMERS
GROUP BY SEGMENT
ORDER BY TOTAL_CUSTOMERS DESC;


