use pizza_sales_db;

-- 📊 Query 1: Total Revenue by Size
SELECT 
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    p.size
ORDER BY 
    total_revenue DESC;
    
-- 📈 Query 2: Revenue Percentage Contribution by Size
WITH size_revenue AS (
    SELECT 
        p.size,
        SUM(od.quantity * p.price) AS revenue
    FROM 
        order_details od
    JOIN 
        pizza p ON od.pizza_id = p.pizza_id
    GROUP BY 
        p.size
),
total AS (
    SELECT SUM(revenue) AS total_revenue FROM size_revenue
)
SELECT 
    sr.size,
    ROUND(sr.revenue, 2) AS revenue,
    ROUND((sr.revenue / t.total_revenue) * 100, 2) AS revenue_percent
FROM 
    size_revenue sr, total t
ORDER BY 
    revenue DESC;
    
-- 🧮 Query 3: Average Revenue per Order by Size
SELECT 
    p.size,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_revenue_per_order
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    p.size
ORDER BY 
    avg_revenue_per_order DESC;
    
-- 📅 Query 4: Monthly Revenue Trend by Size (MySQL version)
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_size_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    month, p.size
ORDER BY 
    month, monthly_size_revenue DESC;
    
    
-- 🏆 Query 5: Top 5 Pizza + Size Combinations by Revenue
SELECT 
    pt.name AS pizza_name,
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name, p.size
ORDER BY 
    revenue DESC
LIMIT 5;

-- 🪜 Query 6: Rank Pizza Sizes by Total Revenue Using Window Function
SELECT 
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(od.quantity * p.price) DESC) AS size_revenue_rank
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    p.size;
    
    
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_size_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    month, p.size
ORDER BY 
    month, monthly_size_revenue DESC;