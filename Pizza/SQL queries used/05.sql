use pizza_sales_db;

-- 🍕 Total Quantity Sold by Category
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY 
    total_quantity_sold DESC;
    
-- 💰 Total Revenue by Category
SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY 
    total_revenue DESC;
    
-- 📊 Revenue % Contribution by Category
WITH category_revenue AS (
    SELECT 
        pt.category,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue
    FROM 
        order_details od
    JOIN 
        pizza p ON od.pizza_id = p.pizza_id
    JOIN 
        pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY 
        pt.category
),
total AS (
    SELECT SUM(revenue) AS total_revenue FROM category_revenue
)
SELECT 
    cr.category,
    cr.revenue,
    ROUND((cr.revenue / t.total_revenue) * 100, 2) AS revenue_percent
FROM 
    category_revenue cr, total t
ORDER BY 
    revenue DESC;
    
-- 📦 Avg Revenue per Order by Category
SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_revenue_per_order
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY 
    avg_revenue_per_order DESC;
    
-- 🥇 Top Pizza by Revenue in Each Category
SELECT 
    pt.category,
    pt.name AS pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category, pt.name
HAVING 
    revenue = (
        SELECT 
            MAX(sub_revenue)
        FROM (
            SELECT 
                pt2.category,
                pt2.name,
                ROUND(SUM(od2.quantity * p2.price), 2) AS sub_revenue
            FROM 
                order_details od2
            JOIN 
                pizza p2 ON od2.pizza_id = p2.pizza_id
            JOIN 
                pizza_types pt2 ON p2.pizza_type_id = pt2.pizza_type_id
            GROUP BY 
                pt2.category, pt2.name
        ) sub
        WHERE sub.category = pt.category
    )
ORDER BY 
    revenue DESC;