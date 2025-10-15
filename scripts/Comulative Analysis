/*
================================================
              Cumulative Analysis
================================================
*/
-- Revised Query to combine year and month into a single column
SELECT
    to_char(date_trunc('month', order_date), 'YYYY-MM') AS month,-- New column for month in 'YYYY-MM' format
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quanity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY to_char(date_trunc('month', order_date), 'YYYY-MM')
ORDER BY to_char(date_trunc('month', order_date), 'YYYY-MM');
