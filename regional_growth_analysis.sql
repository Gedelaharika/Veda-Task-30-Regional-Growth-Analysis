USE veda_task30;

WITH regional_sales AS (
    SELECT
        YEAR(order_date) AS year,
        region,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY YEAR(order_date), region
),
growth_data AS (
    SELECT
        year,
        region,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY region
            ORDER BY year
        ) AS previous_year_sales
    FROM regional_sales
)
SELECT
    year,
    region,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        ((total_sales - previous_year_sales)
        / previous_year_sales) * 100,
        2
    ) AS growth_percentage
FROM growth_data
WHERE previous_year_sales IS NOT NULL
ORDER BY year, region;