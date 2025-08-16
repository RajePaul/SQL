# 🍕 03_top_5_most_ordered_pizzas.md

## 🎯 Objective:
Identify the **Top 5 Most Ordered Pizzas** in terms of **quantity sold** to understand customer preferences and high-demand products. This insight helps guide inventory, promotions, and menu design.

---

## 🔍 Query 1: Top 5 Pizzas by Quantity Sold

This query gives a ranked list of pizzas based on total quantity sold. It shows which pizzas are most popular, regardless of price or revenue.

```sql
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
```


### ✅ 1. Top 5 Most Ordered Pizzas

**Query**: Aggregates total quantity sold for each pizza and returns the top 5.

| 🥇 Rank | 🍕 Pizza Name                  | 🧮 Quantity Sold |
|--------|--------------------------------|------------------|
| 1      | The Classic Deluxe Pizza       | 2,453            |
| 2      | The Barbecue Chicken Pizza     | 2,432            |
| 3      | The Hawaiian Pizza             | 2,422            |
| 4      | The Pepperoni Pizza            | 2,418            |
| 5      | The Thai Chicken Pizza         | 2,371            |

**Insight**:
- All top 5 pizzas crossed **2,300+** orders.
- Marginal differences suggest tight competition among favorites.
---

## 🔍 Query 2: Top 5 Pizzas by Quantity and Category

This variation of the first query adds category context to each pizza. It helps understand if certain pizza types (Veggie, Meat, Classic) dominate the top-selling list.
```sql
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
```

### ✅ 2. Category Distribution of Top 5 Pizzas

| 🍕 Pizza Name                  | 🗂️ Category |
|-------------------------------|-------------|
| The Classic Deluxe Pizza      | Classic     |
| The Barbecue Chicken Pizza    | Chicken     |
| The Hawaiian Pizza            | Classic     |
| The Pepperoni Pizza           | Classic     |
| The Thai Chicken Pizza        | Chicken     |

**Insight**:
- **Classic** category dominates the leaderboard with 3 entries.
- **Chicken** category holds 2 top spots, highlighting strong popularity.

**Business Implication**:
- Classic pizzas are customer staples — keep consistent availability.
- Chicken pizzas show competitive edge — leverage in meal deals or upsell strategies.

---

## 🔍 Query 3: Ranked Pizza Quantity (Window Function)

This query provides a ranking of all pizzas using the RANK() window function. It’s ideal for building a leaderboard or dynamically highlighting best-sellers without needing a LIMIT.

```sql
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
```

### ✅ 3. Full Pizza Popularity Ranking

**Query**: Ranks all pizzas by total quantity sold using SQL `RANK()`.

| 🏅 Rank | 🍕 Pizza Name                             | 🧮 Quantity Sold |
|--------|-------------------------------------------|------------------|
| 1      | The Classic Deluxe Pizza                  | 2,453            |
| 2      | The Barbecue Chicken Pizza                | 2,432            |
| 3      | The Hawaiian Pizza                        | 2,422            |
| 4      | The Pepperoni Pizza                       | 2,418            |
| 5      | The Thai Chicken Pizza                    | 2,371            |
| ...    | ...                                       | ...              |
| 13     | The Vegetables + Vegetables Pizza         | 1,526            |
| 24     | The Chicken Alfredo Pizza                 | 987              |
| 32     | The Brie Carre Pizza                      | 490              |

**Observation**:
- The top 10 pizzas sold over **1,900 units** each.
- Even the **least ordered pizza** (Brie Carre) sold **490 units**, indicating steady baseline demand.


---

## 🧠 Final Takeaways

- **Top Sellers**:
  - **The Classic Deluxe Pizza** leads the market.
  - **Barbecue Chicken** and **Hawaiian** are close competitors.
- **Category Strength**:
  - Focus on **Classic** and **Chicken** pizzas in campaigns and bundles.
- **Menu Optimization**:
  - Highlight top 5 pizzas in promotions.
  - Evaluate mid- and low-performing pizzas for potential rebranding or improvement.

---

