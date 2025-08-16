-- 📊 Monthly Revenue Trends Analysis

-- This analysis explores revenue patterns on a **monthly basis** to uncover trends, average order values, category performance, and growth rates. Such insights help businesses plan seasonal promotions, manage inventory, and understand demand fluctuations.

use pizza_sales_db;



-- Query 1: Total Monthly Revenue


SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_revenue
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    month
ORDER BY 
    month;








-- 📦 Query 2: Average Order Value Per Month


SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    month
ORDER BY 
    month;


-- 🍕 Query 3: Monthly Revenue by Pizza Category


SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS category_revenue
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    month, pt.category
ORDER BY 
    month, category_revenue DESC;






-- 📈 Query 4: Month-over-Month Growth Rate

WITH monthly_rev AS (
    SELECT 
        DATE_FORMAT(o.date, '%Y-%m') AS month,
        SUM(od.quantity * p.price) AS revenue
    FROM 
        orders o
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        pizza p ON od.pizza_id = p.pizza_id
    GROUP BY 
        month
)
SELECT 
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS mom_growth_percent
FROM 
    monthly_rev;




### 