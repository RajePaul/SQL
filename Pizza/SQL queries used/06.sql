use pizza_sales_db;

SELECT 
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    total_quantity_sold DESC
LIMIT 5;

-- Step 1: Get top 5 best-selling pizza names
SELECT 
    pt_top.name AS pizza_name,
    pt_top.ingredients
FROM (
    SELECT 
        pt.name,
        SUM(od.quantity) AS total_quantity_sold
    FROM 
        order_details od
    JOIN 
        pizza p ON od.pizza_id = p.pizza_id
    JOIN 
        pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY 
        pt.name
    ORDER BY 
        total_quantity_sold DESC
    LIMIT 5
) AS top_pizzas
JOIN pizza_types pt_top ON top_pizzas.name = pt_top.name;