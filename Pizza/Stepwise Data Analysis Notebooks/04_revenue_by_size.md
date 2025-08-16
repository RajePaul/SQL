## 📊 Query 1: Total Revenue by Size

- Find out the overall contribution of each pizza size to total revenue.

```sql
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
```
### 1. Total Revenue by Pizza Size

| Size | Total Revenue (₹) |
|------|-------------------|
| L    | 375,318.70        |
| M    | 249,382.25        |
| S    | 178,076.50        |
| XL   | 14,076.00         |
| XXL  | 1,006.60          |

- **Large (L)** pizzas generate the highest revenue, nearly double the medium (M) size.
- Extra Large (XL) and Double Extra Large (XXL) sizes contribute minimal revenue.

---

---

##  📈 Query 2: Revenue Percentage Contribution by Size

- Understand revenue share per size compared to the overall revenue.

```sql
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
```
### 2. Revenue Share Percentage by Pizza Size

| Size | Revenue (₹) | % of Total Revenue |
|------|-------------|--------------------|
| L    | 375,318.70  | 45.89%             |
| M    | 249,382.25  | 30.49%             |
| S    | 178,076.50  | 21.77%             |
| XL   | 14,076.00   | 1.72%              |
| XXL  | 1,006.60    | 0.12%              |

- Large and Medium pizzas together contribute over 75% of total revenue.
- Smaller sizes (S) still hold a significant share (~22%).
---
##  🧮 Query 3: Average Revenue per Order by Size

- Determine which size yields higher revenue per order on average.

```sql
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

```

### 3. Average Revenue Per Order by Pizza Size

| Size | Avg. Revenue per Order (₹) |
|------|----------------------------|
| XXL  | 35.95                      |
| L    | 29.47                      |
| XL   | 25.88                      |
| M    | 22.35                      |
| S    | 16.98                      |

- XXL pizzas generate the highest revenue per order, despite low overall volume.
- Small size pizzas have the lowest average revenue per order.
----

## 📅 Query 4: Monthly Revenue Trend by Size

- Track performance of each pizza size over months.

```sql
SELECT 
    strftime('%Y-%m', o.date) AS month,
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
```
### 4. Monthly Revenue Trends by Pizza Size

| Month   | Size | Monthly Revenue (₹) |
|---------|------|---------------------|
| 2015-01 | L    | 32,399.40           |
| 2015-01 | M    | 20,943.50           |
| 2015-01 | S    | 15,103.50           |
| 2015-01 | XL   | 1,275.00            |
| 2015-01 | XXL  | 71.90               |
| ...     | ...  | ...                 |
| 2015-12 | L    | 29,712.20           |
| 2015-12 | M    | 19,650.50           |
| 2015-12 | S    | 14,333.50           |
| 2015-12 | XL   | 969.00              |
| 2015-12 | XXL  | 35.95               |

- Revenue remains consistently highest for **Large (L)** pizzas across all months.
- Medium (M) and Small (S) pizzas follow similar seasonal trends.
- XL and XXL sizes contribute minor monthly revenue.

---

## 🏆 Query 5: Top 5 Pizza + Size Combinations by Revenue

- Rank the most profitable size and pizza combinations.

```sql
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
```

### 5. Top 5 Highest Revenue-Generating Pizzas by Size

| Pizza Name               | Size | Revenue (₹) |
|-------------------------|------|-------------|
| The Thai Chicken Pizza   | L    | 29,257.50   |
| The Five Cheese Pizza    | L    | 26,066.50   |
| The Four Cheese Pizza    | L    | 23,622.20   |
| The Spicy Italian Pizza  | L    | 23,011.75   |
| The Big Meat Pizza       | S    | 22,968.00   |

- Large pizzas dominate the top revenue-generating list.
- The Big Meat Pizza (Small size) is the only small pizza in the top 5, showing strong niche demand.
---

## 🪜 Query 6: Rank Pizza Sizes by Total Revenue Using Window Function

- Rank pizza sizes using RANK() for analytical reporting.

```sql
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
```

### 6. Revenue Ranking of Pizza Sizes

| Size | Total Revenue (₹) | Rank |
|------|-------------------|------|
| L    | 375,318.70        | 1    |
| M    | 249,382.25        | 2    |
| S    | 178,076.50        | 3    |
| XL   | 14,076.00         | 4    |
| XXL  | 1,006.60          | 5    |

- Size ranking aligns with total revenue contributions.


---
## 🪜 Query 6: Monthly Revenue by Pizza Size

```sql
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
```

### Monthly Revenue by Pizza Size (2015)

| Month   | Size | Monthly Revenue (₹) |
|---------|------|---------------------|
| 2015-01 | L    | 32,399.40           |
| 2015-01 | M    | 20,943.50           |
| 2015-01 | S    | 15,103.50           |
| 2015-01 | XL   | 1,275.00            |
| 2015-01 | XXL  | 71.90               |
| ...     | ...  | ...                 |
| 2015-12 | L    | 29,712.20           |
| 2015-12 | M    | 19,650.50           |
| 2015-12 | S    | 14,333.50           |
| 2015-12 | XL   | 969.00              |
| 2015-12 | XXL  | 35.95               |

---



- **Large (L)** pizzas consistently generate the highest revenue (~₹29K–₹33K monthly).
- **Medium (M)** and **Small (S)** sizes contribute steady revenue but less than Large.
- **XL** and **XXL** sizes have minimal revenue, indicating low demand.
- Monthly revenues are stable with no significant seasonal spikes.
- Focus marketing and inventory on Large pizzas for maximum revenue.
- Consider reviewing XL and XXL size offerings due to low sales.

---
---
## 📌 **Summary & Business Insights**

- **Large pizzas (L)** are the top revenue drivers, nearly 46% of total revenue.
- Medium and Small sizes are significant but less profitable than Large.
- XXL and XL sizes generate minimal revenue and may be reconsidered for inventory or marketing focus.
- Average revenue per order is highest for XXL, indicating potential for premium pricing strategies.
- Monthly trends are stable with no major seasonal dips, allowing predictable inventory planning.
- Highlighting top revenue pizzas in marketing can boost sales further.

---
