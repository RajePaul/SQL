-- ===============================================
-- 🍕 01_total_revenue.sql
-- Total Revenue Analysis for Pizza Sales Database
-- ===============================================
-- Objective: Derive key revenue insights across pizza types, sizes, categories, and orders.
-- ===============================================
use pizza_sales_db;
-- 🔍 Query 1: Total Revenue (Overall)
-- This query calculates the total revenue by multiplying quantity with price for every order.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id;

-- 🔍 Query 2: Revenue by Pizza Type
-- This shows which pizza types (e.g., BBQ Chicken, Margherita) generate the most revenue.
SELECT 
    pt.name AS pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    revenue DESC;

-- 🔍 Query 3: Revenue by Pizza Size
-- Helps identify which pizza size (S, M, L, XL, etc.) contributes the most to revenue.
SELECT 
    p.size,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    p.size
ORDER BY 
    revenue DESC;

-- 🔍 Query 4: Revenue by Category
-- Analyze total revenue for each category (Classic, Chicken, Veggie, etc.)
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
ORDER BY 
    revenue DESC;

-- 🔍 Query 5: Top 10 Revenue-Generating Pizzas
-- Identify the specific pizza SKUs (id) that earn the most revenue.
SELECT 
    od.pizza_id,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    od.pizza_id
ORDER BY 
    revenue DESC
LIMIT 10;

-- 🔍 Query 6: Top 10 Orders by Revenue
-- This query shows the top 10 most valuable customer orders.
SELECT 
    od.order_id,
    ROUND(SUM(od.quantity * p.price), 2) AS order_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    od.order_id
ORDER BY 
    order_revenue DESC
LIMIT 10;

-- 🔍 Query 7: Revenue by Pizza Type and Size (Using CTE)
-- Reveals which type-size combinations generate the most money.
WITH revenue_cte AS (
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
)
SELECT *
FROM revenue_cte
ORDER BY revenue DESC
LIMIT 15;

-- 🔍 Query 8: Ranked Revenue by Pizza (Using Window Function)
-- Ranks all pizzas by total revenue using RANK(), not just top 10.
SELECT 
    pt.name AS pizza_name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(od.quantity * p.price) DESC) AS revenue_rank
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name;