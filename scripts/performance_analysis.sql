

/*
================================================
              Performance Analysis
================================================
*/

--Analyze the yearly performance of products by comparing their sales
--to both the avg sales performance of the product and the previous year's sales
WITH yearly_product_sales AS (
SELECT
    EXTRACT(YEAR FROM f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM f.order_date), p.product_name
ORDER BY EXTRACT(YEAR FROM f.order_date), p.product_name
) 
SELECT 
    order_year,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 1) AS avg_sales,
    current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 1) AS diff_avg,
    CASE WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 1) > 0 
         THEN 'Above Average' 
         WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 1) < 0 
         THEN 'Below Average' 
         ELSE 'Average' 
    END AS performance_vs_avg,-- Performance vs average sales
    --Year-over-year comparison
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_previous_year,
    CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 
         THEN 'Improved' 
         WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 
         THEN 'Declined' 
         ELSE 'No Change' 
    END AS performance_vs_previous_year-- Performance vs previous year
FROM yearly_product_sales
ORDER BY product_name, order_year; 
