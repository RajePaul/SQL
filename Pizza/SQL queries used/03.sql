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

SELECT 
    pt.name AS pizza_name,
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name, pt.category
ORDER BY 
    total_quantity_sold DESC
LIMIT 5;

SELECT 
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold,
    RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS quantity_rank
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name;