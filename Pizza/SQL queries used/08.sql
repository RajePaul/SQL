use pizza_sales_db;

-- 1
WITH pizza_sales AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity) AS total_quantity,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    total_quantity
FROM 
    pizza_sales
WHERE 
    rk <= 3
ORDER BY 
    category, total_quantity DESC;
    
-- 2

WITH pizza_revenue AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS total_revenue,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM 
    pizza_revenue
WHERE 
    rk <= 3
ORDER BY 
    category, total_revenue DESC;
    
-- 3

WITH pizza_avg_quantity AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_quantity_per_order,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    avg_quantity_per_order
FROM 
    pizza_avg_quantity
WHERE 
    rk <= 3
ORDER BY 
    category, avg_quantity_per_order DESC;
    
    
-- 4

WITH pizza_avg_revenue AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_revenue_per_order,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    avg_revenue_per_order
FROM 
    pizza_avg_revenue
WHERE 
    rk <= 3
ORDER BY 
    category, avg_revenue_per_order DESC;