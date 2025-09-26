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
