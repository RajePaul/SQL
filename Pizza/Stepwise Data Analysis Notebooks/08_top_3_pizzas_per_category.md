# 🍕 Top 3 Pizzas per Category Analysis

In this analysis, we identify the top 3 performing pizzas **within each category** using four different advanced SQL queries. This helps us understand not just the best overall pizzas, but the **leaders in each category** by quantity, revenue, and per-order performance.

---

🔍 Objective :

To determine the **top 3 pizzas per category** using:
1. Total Quantity Sold
2. Total Revenue Generated
3. Average Quantity per Order
4. Average Revenue per Order

### 🧠 SQL Concepts Used
- `RANK() OVER (PARTITION BY ...)`: Advanced window function to rank pizzas *within each category*.
- Aggregation with `SUM()`, `COUNT(DISTINCT ...)`, and `ROUND()`
- Common Table Expressions (CTEs)
- Multi-level ordering and filtering




## 🔢 1. Top 3 Pizzas per Category by Total Quantity Sold

```sql
WITH pizza_sales AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity) AS total_quantity,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    total_quantity
FROM 
    pizza_sales
WHERE 
    rk <= 3
ORDER BY 
    category, total_quantity DESC;
```

### 1️⃣ **Top 3 Pizzas by Total Quantity Sold (per Category)**

| Category | Pizza Name                         | Total Quantity |
|----------|------------------------------------|----------------|
| Chicken  | The Barbecue Chicken Pizza         | 2432           |
|          | The Thai Chicken Pizza             | 2371           |
|          | The California Chicken Pizza       | 2370           |
| Classic  | The Classic Deluxe Pizza           | 2453           |
|          | The Hawaiian Pizza                 | 2422           |
|          | The Pepperoni Pizza                | 2418           |
| Supreme  | The Sicilian Pizza                 | 1938           |
|          | The Spicy Italian Pizza            | 1924           |
|          | The Italian Supreme Pizza          | 1884           |
| Veggie   | The Four Cheese Pizza              | 1902           |
|          | The Vegetables + Vegetables Pizza  | 1526           |
|          | The Mexicana Pizza                 | 1484           |

✅ **Insight**:

 Classic and Chicken pizzas dominate volume. The Barbecue Chicken and Classic Deluxe are customer favorites.

---

## 💰 2. Top 3 Pizzas per Category by Total Revenue

```sql
WITH pizza_revenue AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS total_revenue,
        RANK() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM 
    pizza_revenue
WHERE 
    rk <= 3
ORDER BY 
    category, total_revenue DESC;
```
### 2️⃣ **Top 3 Pizzas by Total Revenue (per Category)**

| Category | Pizza Name                         | Total Revenue |
|----------|------------------------------------|----------------|
| Chicken  | The Thai Chicken Pizza             | 43434.25       |
|          | The Barbecue Chicken Pizza         | 42768.00       |
|          | The California Chicken Pizza       | 41409.50       |
| Classic  | The Classic Deluxe Pizza           | 38180.50       |
|          | The Hawaiian Pizza                 | 32273.25       |
|          | The Pepperoni Pizza                | 30161.75       |
| Supreme  | The Spicy Italian Pizza            | 34831.25       |
|          | The Italian Supreme Pizza          | 33476.75       |
|          | The Sicilian Pizza                 | 30940.50       |
| Veggie   | The Four Cheese Pizza              | 32265.70       |
|          | The Mexicana Pizza                 | 26780.75       |
|          | The Five Cheese Pizza              | 26066.50       |

✅ **Insight**: 

Revenue leaders closely follow quantity leaders, but Veggie and Supreme pizzas start showing higher value.

---

## 📦 3. Top 3 Pizzas per Category by Number of Orders (Order Count)

```sql
WITH pizza_orders AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        COUNT(DISTINCT od.order_id) AS order_count,
        RANK() OVER (PARTITION BY pt.category ORDER BY COUNT(DISTINCT od.order_id) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    order_count
FROM 
    pizza_orders
WHERE 
    rk <= 3
ORDER BY 
    category, order_count DESC;
```
### 3️⃣ **Top 3 Pizzas by Avg. Quantity per Order (per Category)**

| Category | Pizza Name                         | Avg Qty/Order |
|----------|------------------------------------|----------------|
| Chicken  | The California Chicken Pizza       | 1.08           |
|          | The Barbecue Chicken Pizza         | 1.07           |
|          | The Thai Chicken Pizza             | 1.07           |
| Classic  | The Hawaiian Pizza                 | 1.06           |
|          | The Pepperoni Pizza                | 1.06           |
|          | The Big Meat Pizza                 | 1.06           |
| Supreme  | The Sicilian Pizza                 | 1.06           |
|          | The Spicy Italian Pizza            | 1.06           |
|          | The Italian Supreme Pizza          | 1.05           |
| Veggie   | The Four Cheese Pizza              | 1.05           |
|          | The Vegetables + Vegetables Pizza  | 1.04           |
|          | The Mexicana Pizza                 | 1.04           |

✅ **Insight**: 

All top pizzas across categories maintain a strong average per order (~1.05+), indicating consistent demand per order.

---

## 💎 4. Top 3 Pizzas per Category by Average Pizzas per Order

```sql
WITH pizza_avg AS (
    SELECT 
        pt.category,
        pt.name AS pizza_name,
        SUM(od.quantity) AS total_quantity,
        COUNT(DISTINCT od.order_id) AS order_count,
        ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_quantity_per_order,
        RANK() OVER (PARTITION BY pt.category ORDER BY ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) DESC) AS rk
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    JOIN pizza_type pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT 
    category,
    pizza_name,
    avg_quantity_per_order
FROM 
    pizza_avg
WHERE 
    rk <= 3
ORDER BY 
    category, avg_quantity_per_order DESC;
```

### 4️⃣ **Top 3 Pizzas by Avg. Revenue per Order (per Category)**

| Category | Pizza Name                         | Avg Rev/Order |
|----------|------------------------------------|----------------|
| Chicken  | The Thai Chicken Pizza             | 19.52          |
|          | The Southwest Chicken Pizza        | 19.02          |
|          | The California Chicken Pizza       | 18.85          |
| Classic  | The Greek Pizza                    | 20.91          |
|          | The Italian Capocollo Pizza        | 18.18          |
|          | The Napolitana Pizza               | 16.95          |
| Supreme  | The Brie Carre Pizza               | 24.14          |
|          | The Spicy Italian Pizza            | 19.12          |
|          | The Italian Supreme Pizza          | 18.69          |
| Veggie   | The Five Cheese Pizza              | 19.18          |
|          | The Mexicana Pizza                 | 18.78          |
|          | The Four Cheese Pizza              | 17.84          |

✅ **Insight**: 

High-priced specialty pizzas like the Brie Carre, Greek, and Five Cheese generate higher revenue per order — suggesting upsell opportunities.

---
## 🎯 Business Impact

- 🏆 **Marketing**: Promote top sellers in each category in ads, combo offers.
- 💰 **Pricing Strategy**: Highlight high avg revenue/order pizzas for premium bundles.
- 📦 **Inventory Planning**: Prioritize ingredients for high-volume and high-revenue pizzas.
- 📈 **Menu Optimization**: Emphasize best-performers across both revenue and volume.

---




