# Sales Data Imputation with SQL

This mini-project demonstrates techniques for handling missing time-series data using SQL. It includes:

- Recursive CTEs to generate complete date ranges
- COALESCE and AVG for null value substitution
- LAG and LEAD functions for forward/backward imputation

## 📊 Dataset

A small sales table with gaps in daily records:
```sql
('2025-01-01', 61),
('2025-01-02', 72),
('2025-01-04', 84),
('2025-01-05', 95),
('2025-01-07', 77)

## 📄 SQL Script
USE temp;

-- Create a sales table
CREATE TABLE sales (
    dt DATE,
    num_sales INT
);

-- Insert sales data into the table
INSERT INTO sales (dt, num_sales)
VALUES
    ('2025-01-01', 61),
    ('2025-01-02', 72),
    ('2025-01-04', 84),
    ('2025-01-05', 95),
    ('2025-01-07', 77);

-- Generate a series of dates using UNION ALL
SELECT 
    sq.date, 
    sales.num_sales
FROM (
    SELECT '2025-01-01' AS date 
    UNION ALL SELECT '2025-01-02' 
    UNION ALL SELECT '2025-01-03' 
    UNION ALL SELECT '2025-01-04' 
    UNION ALL SELECT '2025-01-05' 
    UNION ALL SELECT '2025-01-06' 
    UNION ALL SELECT '2025-01-07'
) AS sq
LEFT JOIN sales ON sales.dt = sq.date;

-- Rewrite CTE as a recursive CTE
WITH cte AS (
    SELECT '2025-01-01' AS date 
    UNION ALL SELECT '2025-01-02' 
    UNION ALL SELECT '2025-01-03' 
    UNION ALL SELECT '2025-01-04' 
    UNION ALL SELECT '2025-01-05' 
    UNION ALL SELECT '2025-01-06' 
    UNION ALL SELECT '2025-01-07'
)
SELECT 
    cte.date, 
    sales.num_sales
FROM cte
LEFT JOIN sales ON sales.dt = cte.date;

-- Fill in null values using recursive CTE and COALESCE
WITH RECURSIVE cte AS (
    SELECT CAST('2025-01-01' AS DATE) AS dt
    UNION ALL
    SELECT dt + INTERVAL 1 DAY
    FROM cte 
    WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT  
    cte.dt,
    sales.num_sales,
    ROUND(COALESCE(sales.num_sales, (SELECT AVG(num_sales) FROM sales)), 1) AS estimate_sales
FROM cte
LEFT JOIN sales ON sales.dt = cte.dt;

-- Estimate missing values using LAG and LEAD
SELECT 
    dt,
    num_sales,
    ROW_NUMBER() OVER () AS row_no,
    LAG(num_sales) OVER () AS prev_sales,
    LEAD(num_sales) OVER () AS next_sales,
    ROUND(COALESCE(num_sales, (LAG(num_sales) OVER () + LEAD(num_sales) OVER ()) / 2)) AS estimate2
FROM sales;

-- Recursive CTE with LAG and LEAD for estimating missing values
WITH RECURSIVE cte AS (
    SELECT CAST('2025-01-01' AS DATE) AS dt
    UNION ALL
    SELECT dt + INTERVAL 1 DAY
    FROM cte 
    WHERE dt < CAST('2025-01-07' AS DATE)
)
SELECT 
    cte.dt,
    ROUND(COALESCE(
        sales.num_sales, 
        (LAG(sales.num_sales) OVER () + LEAD(sales.num_sales) OVER ()) / 2
    )) AS estimate2
FROM cte
LEFT JOIN sales ON sales.dt = cte.dt;
