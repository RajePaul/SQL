use pizza_sales_db;

-- 1

SELECT 
    DAYNAME(date) AS day_of_week,
    COUNT(*) AS total_orders
FROM 
    orders
GROUP BY 
    day_of_week
ORDER BY 
    total_orders DESC;
    
-- 2
SELECT 
    DAYNAME(date) AS day_of_week,
    COUNT(*) AS total_orders
FROM 
    orders
GROUP BY 
    day_of_week
ORDER BY 
    FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
    
-- 3

SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity) / COUNT(DISTINCT o.order_id), 2) AS avg_pizzas_per_order
FROM 
    order_details od
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    avg_pizzas_per_order DESC;
    
-- 4

SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    total_revenue DESC;
    
-- 5

SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue_per_order
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    avg_revenue_per_order DESC;
    
-- 6 

SELECT 
    HOUR(time) AS hour,
    COUNT(*) AS order_count
FROM 
    orders
GROUP BY 
    hour
ORDER BY 
    order_count DESC;
    

    
