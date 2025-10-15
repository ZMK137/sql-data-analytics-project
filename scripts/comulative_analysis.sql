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

-- Calculate the total sales per month
-- and the running total of sales over time 

SELECT
    to_char(date_trunc('month', order_date), 'YYYY-MM') AS month,
    SUM(sales_amount) AS total_sales,
    SUM(SUM(sales_amount)) OVER (ORDER BY date_trunc('month', order_date)) AS running_total_sales,
    ROUND(AVG(price), 1)  AS avg_price,
    ROUND(AVG(AVG(price)) OVER (ORDER BY date_trunc('month', order_date)), 1) AS running_avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY to_char(date_trunc('month', order_date), 'YYYY-MM'), date_trunc('month', order_date)
ORDER BY to_char(date_trunc('month', order_date), 'YYYY-MM');
