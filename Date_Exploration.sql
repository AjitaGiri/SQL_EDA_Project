-- Find the date of first and last order
-- How many years of sales are available

SELECT
MIN(order_date) as first_order_date,
MAX(order_date) as last_order_date,
DATEDIFF(year,MIN(order_date),MAX(order_date)) as order_range_years
FROM gold.fact_sales;

-- Find the youngest and the older customer
SELECT
MIN(birthdate) as oldest_customer,
MAX(birthdate) as youngest_customer
FROM gold.dim_customers;