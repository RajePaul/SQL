use pizza_sales_db;


-- 1
SELECT 
    HOUR(time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

-- 2 
SELECT 
    HOUR(o.time) AS order_hour,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_hour
ORDER BY order_hour;

-- 3 

SELECT 
    DAYNAME(o.date) AS day_name,
    HOUR(o.time) AS hour,
    COUNT(*) AS total_orders
FROM orders o
GROUP BY day_name, hour
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), hour;

-- 4

SELECT 
    HOUR(o.time) AS order_hour,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizza p ON od.pizza_id = p.pizza_id
GROUP BY order_hour
ORDER BY total_revenue DESC
LIMIT 5;

-- 5 

SELECT 
    CASE 
        WHEN HOUR(time) BETWEEN 0 AND 9 THEN 'Low Load'
        WHEN HOUR(time) BETWEEN 10 AND 14 THEN 'Mid Load'
        WHEN HOUR(time) BETWEEN 15 AND 21 THEN 'High Load'
        ELSE 'Low Load'
    END AS load_window,
    COUNT(*) AS total_orders
FROM orders
GROUP BY load_window
ORDER BY FIELD(load_window, 'High Load', 'Mid Load', 'Low Load');