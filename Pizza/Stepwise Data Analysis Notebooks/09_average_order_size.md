# Average order size Analysis

🎯 Objective of This Query

The goal is to calculate the average number of pizzas ordered per order, also known as Average Order Size (AOS). This is a crucial operational and marketing metric that reflects:
- Customer appetite
- Bundle effectiveness
- Cross-sell performance
- Inventory and staffing efficiency

```sql
SELECT 
    ROUND(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id), 2) AS avg_order_size
FROM 
    order_details;
```

### Overall Average Order Size (AOS)
- **Result:** 2.32 pizzas per order
- **Insight:** Customers typically order about 2 pizzas per order. This is the baseline for comparing further segment-wise behaviors.



----

## 1. 📆 Monthly Average Order Size Trend

Tracks how AOS evolves over time — helps spot demand seasonality or campaign impact.

```sql
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY month
ORDER BY month;
```
### 1. Monthly Trends

| Month | Average Order Size (AOS) |
|-------|--------------------------|
| Jan–Jul | 2.26 – 2.32 (Slightly below average) |
| Aug | 2.26 (Lowest) |
| Oct–Nov | 2.36 – 2.38 (Peaks) |

**Insights:**
- Slight dip during summer months (July–August), possibly seasonal slowdown.
- Peak in Q4 (October–November) likely due to holidays or festive promotions.
- Suggestion: Optimize campaign timing and inventory management accordingly.

---

## 2. 🍕 Average Order Size by Pizza Category

Shows if some categories tend to drive bulk orders (e.g. Classic vs Veggie).

```sql
SELECT 
    pt.category,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN pizza p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY avg_order_size DESC;
```
### 2. Average Order Size by Pizza Category

| Category | AOS |
|----------|-----|
| Classic  | 1.37 |
| Supreme  | 1.32 |
| Veggie   | 1.30 |
| Chicken  | 1.29 |

**Insights:**
- Classic pizzas tend to be ordered in slightly larger quantities.
- Chicken pizzas are less frequently ordered in bulk, possibly premium items.
- Opportunity to create combo offers around Veggie and Chicken pizzas to boost cart size.

---

## 3. 📏 Average Order Size by Pizza Size (S/M/L/XL)

Determines whether customers ordering small sizes tend to order more pizzas per order.


```sql
SELECT 
    p.size,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN pizza p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY FIELD(p.size, 'S', 'M', 'L', 'XL');
```
### 3. Average Order Size by Pizza Size

| Size | AOS |
|------|-----|
| M    | 1.40 |
| L    | 1.49 |
| S    | 1.37 |
| XL   | 1.01 |
| XXL  | 1.00 |

**Insights:**
- L-sized pizzas have the highest average order size.
- XL and XXL sizes have low average order sizes, indicating customers often order only one large pizza.
- Larger sizes may satisfy group orders alone; M and L sizes better candidates for bundling and upselling.

---

## 4. 🕓 Average Order Size by Day of Week

Optimizes staffing and marketing per weekday based on ordering patterns.

```sql
SELECT 
    DAYNAME(o.date) AS day_name,
    ROUND(SUM(od.quantity) * 1.0 / COUNT(DISTINCT od.order_id), 2) AS avg_order_size
FROM 
    order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
```
### 4. Average Order Size by Day of the Week

| Day       | AOS |
|-----------|-----|
| Saturday  | 2.37 |
| Friday    | 2.33 |
| Monday–Thursday | 2.30 – 2.32 |

**Insights:**
- Weekend orders are larger, likely due to family or party orders.
- Staffing, preparation, and marketing should be adjusted to accommodate higher weekend volume.

---

## 5. 🧑‍💼 High vs Low Value Orders — AOS Comparison

Compare AOS for orders above and below average revenue.


```sql
WITH order_totals AS (
    SELECT 
        od.order_id,
        SUM(od.quantity * p.price) AS order_revenue,
        SUM(od.quantity) AS order_quantity
    FROM 
        order_details od
    JOIN pizza p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
),
avg_revenue AS (
    SELECT AVG(order_revenue) AS avg_order_revenue FROM order_totals
)
SELECT 
    CASE WHEN ot.order_revenue >= ar.avg_order_revenue THEN 'High Value Order'
         ELSE 'Low Value Order' END AS order_type,
    ROUND(AVG(order_quantity), 2) AS avg_order_size
FROM 
    order_totals ot, avg_revenue ar
GROUP BY order_type;
```
### 5. Average Order Size for Low vs High Value Orders

| Order Type      | AOS |
|-----------------|-----|
| Low Value Order | 1.41 |
| High Value Order| 3.90 |

**Insights:**
- High revenue orders have approximately 2.5 times more pizzas than low value orders.
- Opportunity to upsell smaller orders through bundle offers or free delivery incentives.

---
## Final Takeaways and Recommendations

| Focus Area          | Action Recommendation                                                  |
|---------------------|------------------------------------------------------------------------|
| 📦 Bundling Strategy | Create combo offers focusing on M/L sizes and Classic/Veggie pizzas.  |
| 🎯 Targeted Promotions | Promote larger orders during weekdays to balance volume and increase revenue. |
| 🧾 Order Segmentation | Implement behavioral targeting for upselling and rewarding high AOS customers. |
| 🧑‍🍳 Operational Readiness | Increase staffing and inventory on weekends and during Q4; reduce during August lull. |
| 📊 Dashboards       | Track AOS KPIs by category, size, and revenue tier for real-time insights. |

---

*This analysis helps optimize marketing, operations, and revenue strategies by leveraging detailed order size insights.*