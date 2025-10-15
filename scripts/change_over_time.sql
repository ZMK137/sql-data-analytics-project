/*
================================================
            Changes over time analysis
================================================
*/
-- Original Query
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quanity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM order_date), EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date), EXTRACT(YEAR FROM order_date);
