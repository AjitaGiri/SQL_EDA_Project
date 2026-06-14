-- Find the total sales
SELECT
SUM(sales_amount) as total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT
SUM(quantity) as total_items
FROM gold.fact_sales;

-- find the average selling price
SELECT
AVG(price) as avg_selling_price
FROM gold.fact_sales;

-- Find the total number of orders
SELECT
COUNT(order_number) as total_no_of_orders
FROM gold.fact_sales;

-- Find the total number of products
SELECT
COUNT(product_name) as total_no_of_products
FROM gold.dim_products;

-- Find the total number of customer.
SELECT
COUNT(customer_key) as total_no_of_customer
FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT
COUNT( DISTINCT customer_key) as total_no_of_customer
FROM gold.fact_sales;

-- Generate Report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name,
SUM(sales_amount) as measure_value
FROM gold.fact_sales
UNION ALL
SELECT
'total_items',
SUM(quantity) 
FROM gold.fact_sales
UNION ALL
SELECT
'avg_selling_price',
AVG(price) 
FROM gold.fact_sales
UNION ALL
SELECT
'total_no_of_orders',
COUNT(order_number) 
FROM gold.fact_sales
UNION ALL
SELECT
'total_no_of_orders',
COUNT(order_number) 
FROM gold.fact_sales
UNION ALL
SELECT
'total_no_of_products',
COUNT(product_name) 
FROM gold.dim_products
UNION ALL
SELECT
'total_no_of_customer',
COUNT(customer_key) 
FROM gold.dim_customers
UNION ALL
SELECT
'total_no_of_customer',
COUNT( DISTINCT customer_key) 
FROM gold.fact_sales;
