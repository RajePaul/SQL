## 🍕 1. Total Quantity Sold by Category

Find out how many pizzas were sold in each category.

```sql
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
```

### 🔢 Total Quantity Sold by Category
| Category | Quantity Sold |
|----------|----------------|
| Classic  | 14,888         |
| Supreme  | 11,987         |
| Veggie   | 11,649         |
| Chicken  | 11,050         |

> 🟢 **Classic** pizzas are the most ordered by quantity.

---

## 💰 2.Total Revenue by Category

Understand which category brings in the most money.

```sql
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
```
### 💰 Total Revenue by Category
| Category | Total Revenue (₹) |
|----------|-------------------|
| Classic  | 220,053.10        |
| Supreme  | 208,197.00        |
| Chicken  | 195,919.50        |
| Veggie   | 193,690.45        |

> 🥇 **Classic** also generates the most revenue.

---

## 📊 3.Revenue % Contribution by Category

Show how much each category contributes to the total revenue, in percentage terms.

```sql
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
```

### 📊 Revenue Contribution Percentage
| Category | Revenue (₹) | % of Total Revenue |
|----------|-------------|---------------------|
| Classic  | 220,053.10  | 26.91%              |
| Supreme  | 208,197.00  | 25.46%              |
| Chicken  | 195,919.50  | 23.96%              |
| Veggie   | 193,690.45  | 23.68%              |

> ✅ All categories contribute fairly evenly. Classic leads with ~27%.
---

## 📦 4.Avg Revenue per Order by Category

Identify which category is most profitable on a per-order basis.

```sql
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
```

### 📦 Avg. Revenue per Order by Category
| Category | Avg Revenue/Order (₹) |
|----------|------------------------|
| Chicken  | 22.95                  |
| Supreme  | 22.92                  |
| Veggie   | 21.66                  |
| Classic  | 20.26                  |

> 🔍 **Chicken** and **Supreme** bring the highest revenue per order.
---

## 🥇 5.Top Pizza by Revenue in Each Category

 Pinpoint the top-selling pizza by revenue within each category.

```sql
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
```
### 🏆 Top Revenue-Generating Pizza per Category
| Category | Top Pizza Name              | Revenue (₹) |
|----------|-----------------------------|--------------|
| Chicken  | The Thai Chicken Pizza      | 43,434.25     |
| Classic  | The Classic Deluxe Pizza    | 38,180.50     |
| Supreme  | The Spicy Italian Pizza     | 34,831.25     |
| Veggie   | The Four Cheese Pizza       | 32,265.70     |

> 🌟 **The Thai Chicken Pizza** is the highest-earning individual pizza.

---
### 📌 Key Takeaways
- **Classic pizzas** dominate in quantity and total revenue.
- **Chicken pizzas** have the highest revenue per order.
- **Top individual pizzas** show strong customer preferences.
- Menu, pricing, and promotions can be tailored by category insights.