use temp;
CREATE TABLE sales (
    dt DATE,
    num_sales INT
);

-- insert sales data into the table
INSERT INTO sales (dt, num_sales)
VALUES
    ('2025-01-01', 61),
    ('2025-01-02', 72),
    ('2025-01-04', 84),
    ('2025-01-05', 95),
    ('2025-01-07', 77);
    
select sq.date, sales.num_sales
from
(select '2025-01-01' as date 
UNION ALL
select '2025-01-02' 
UNION ALL
select '2025-01-03'
UNION ALL
select '2025-01-04'
UNION All
select '2025-01-05'
UNION ALL
select '2025-01-06'
UNION ALL
select '2025-01-07'
)as sq
left join sales on sales.dt = sq.date;


with cte as(
			select '2025-01-01' as date 
			UNION ALL
			select '2025-01-02' 
			UNION ALL
			select '2025-01-03'
			UNION ALL
			select '2025-01-04'
			UNION All
			select '2025-01-05'
			UNION ALL
			select '2025-01-06'
			UNION ALL
			select '2025-01-07'
)

select cte.date ,sales.num_sales
from cte
left join sales on sales.dt = cte.date;


WITH RECURSIVE cte AS(
			SELECT cast('2025-01-01'as DATE) as dt
			UNION ALL
			SELECT dt + INTERVAL 1 DAY
            from cte where dt < cast('2025-01-07' as date)
)
SELECT * FROM cte;
