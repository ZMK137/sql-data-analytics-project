/*
================================================
              Proportional Analysis
================================================
*/

--Which categories contribiute tho most to overall sales?
WITH category_sales AS (
SELECT
    category,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY category
ORDER BY total_sales DESC
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS NUMERIC)/SUM(total_sales) OVER ()) * 100, 2), '%') AS sales_percentage
FROM category_sales
ORDER BY total_sales DESC;
