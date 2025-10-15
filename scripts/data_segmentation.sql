/*
================================================
              Data Segmentation
================================================
*/

--Segment products into costs ranges and count how many products fall into each segment
WITH product_cost_segments AS (
SELECT
    product_key,
    product_name,
    product_cost,
    CASE
        WHEN product_cost < 100 THEN 'Below 100'
        WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS cost_segment
FROM gold.dim_products
)
SELECT
    cost_segment,
    COUNT(product_key) AS total_products
FROM product_cost_segments
GROUP BY cost_segment
ORDER BY total_products DESC;

--Segment customers based on their total purchase amounts and count how many customers fall into each segment
WITH customer_spending AS(
SELECT
    c.customer_key,
    SUM(f.sales_amount) AS total_spending,
    MIN(f.order_date) AS first_order,
    MAX(f.order_date) AS last_order,
    EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
    customer_key,
    total_spending,
    lifespan,
    CASE WHEN lifespan >=12 AND total_spending > 5000 THEN 'VIP'
         WHEN lifespan >=12 AND total_spending <= 5000 THEN 'Regular'
         ELSE 'New'
    END AS customer_segment
FROM customer_spending
