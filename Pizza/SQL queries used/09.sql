use pizza_sales_db;

SELECT 
    ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id), 2) AS avg_order_size
FROM 
    order_details;


-- 1 

SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY month
ORDER BY month;

-- 2

SELECT 
    pt.category,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN pizza p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY avg_order_size DESC;


-- 3 

SELECT 
    p.size,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN pizza p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY FIELD(p.size, 'S', 'M', 'L', 'XL');

-- 4

SELECT 
    DAYNAME(o.date) AS day_name,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');


-- 5

WITH order_totals AS (
    SELECT 
        od.order_id,
        SUM(od.quantity * p.price) AS order_revenue,
        SUM(od.quantity) AS order_quantity
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
),
avg_revenue AS (
    SELECT AVG(order_revenue) AS avg_order_revenue FROM order_totals
)
SELECT 
    CASE WHEN ot.order_revenue >= ar.avg_order_revenue THEN 'High Value Order'
         ELSE 'Low Value Order' END AS order_type,
    ROUND(AVG(order_quantity), 2) AS avg_order_size
FROM 
    order_totals ot, avg_revenue ar
GROUP BY order_type;