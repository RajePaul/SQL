# 📊 Orders Per Day of Week Analysis

## 1.Basic Orders per Weekday

Identify which days have the highest number of total orders.

```sql
SELECT 
    DAYNAME(date) AS day_of_week,
    COUNT(*) AS total_orders
FROM 
    orders
GROUP BY 
    day_of_week
ORDER BY 
    total_orders DESC;
```

### 📅 Total Orders by Day of Week (Descending)

| day_of_week | total_orders |
|-------------|--------------|
| Friday      | 3538         |
| Thursday    | 3239         |
| Saturday    | 3158         |
| Wednesday   | 3024         |
| Tuesday     | 2973         |
| Monday      | 2794         |
| Sunday      | 2624         |

**🧠 Insight:**  
**Friday** sees the highest number of orders, indicating peak business. **Sunday** has the least, possibly due to reduced operational hours or lower customer activity.

---

## 2.Orders Sorted by Actual Weekday Order

Aligns data for visualization (useful in bar charts or reports).

```sql
SELECT 
    DAYNAME(date) AS day_of_week,
    COUNT(*) AS total_orders
FROM 
    orders
GROUP BY 
    day_of_week
ORDER BY 
    FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
```



### 📅 Total Orders by Day of Week (Chronological)

| day_of_week | total_orders |
|-------------|--------------|
| Monday      | 2794         |
| Tuesday     | 2973         |
| Wednesday   | 3024         |
| Thursday    | 3239         |
| Friday      | 3538         |
| Saturday    | 3158         |
| Sunday      | 2624         |

**🧠 Insight:**  
There is a gradual increase in order volume from **Monday to Friday**, peaking on Friday, followed by a dip over the weekend.

---

## 3.Average Pizzas Ordered per Day of Week

Understand customer behavior—are more pizzas ordered on weekends?

```sql
SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity) / COUNT(DISTINCT o.order_id), 2) AS avg_pizzas_per_order
FROM 
    order_details od
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    avg_pizzas_per_order DESC;
```
### 🍕 Average Pizzas Per Order by Day

| day_of_week | avg_pizzas_per_order |
|-------------|----------------------|
| Saturday    | 2.37                 |
| Friday      | 2.33                 |
| Monday      | 2.32                 |
| Tuesday     | 2.32                 |
| Thursday    | 2.31                 |
| Sunday      | 2.30                 |
| Wednesday   | 2.30                 |

**🧠 Insight:**  
**Saturday** shows the highest average number of pizzas per order, likely due to group or family orders. Weekdays, especially Monday and Tuesday, also have strong per-order volume, indicating potential bulk or office orders.

---



## 4.Total Revenue per Weekday

Revenue insight per weekday—are fewer orders on some days making more money?

```sql
SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    total_revenue DESC;
```


### 💰 Total Revenue by Day of Week

| day_of_week | total_revenue |
|-------------|----------------|
| Friday      | 136073.90      |
| Thursday    | 123528.50      |
| Saturday    | 123182.40      |
| Wednesday   | 114408.40      |
| Tuesday     | 114133.80      |
| Monday      | 107329.55      |
| Sunday      | 99203.50       |

**🧠 Insight:**  
**Friday** dominates in total revenue. Even with fewer orders, **Saturday** closely follows Thursday, showing that weekend orders tend to be larger or more premium.

---

## 5.Average Revenue per Order per Weekday

Efficiency metric—high revenue per order means premium orders on that day.

```sql
SELECT 
    DAYNAME(o.date) AS day_of_week,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_revenue_per_order
FROM 
    order_details od
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    orders o ON od.order_id = o.order_id
GROUP BY 
    day_of_week
ORDER BY 
    avg_revenue_per_order DESC;
```


### 💵 Average Revenue Per Order by Day

| day_of_week | avg_revenue_per_order |
|-------------|------------------------|
| Saturday    | 39.01                  |
| Friday      | 38.46                  |
| Monday      | 38.41                  |
| Tuesday     | 38.39                  |
| Thursday    | 38.14                  |
| Wednesday   | 37.83                  |
| Sunday      | 37.81                  |

**🧠 Insight:**  
**Saturday** generates the highest average revenue per order, confirming the trend of larger or more expensive purchases during the weekend.

---

## 6.Orders Distribution by Hour of Day (Bonus Insight)

```sql
SELECT 
    HOUR(time) AS hour,
    COUNT(*) AS order_count
FROM 
    orders
GROUP BY 
    hour
ORDER BY 
    order_count DESC;
```

### ⏰ Orders Per Hour

| hour | order_count |
|------|--------------|
| 12   | 2520         |
| 13   | 2455         |
| 18   | 2399         |
| 17   | 2336         |
| 19   | 2009         |
| 16   | 1920         |
| 20   | 1642         |
| 14   | 1472         |
| 15   | 1468         |
| 11   | 1231         |
| 21   | 1198         |
| 22   | 663          |
| 23   | 28           |
| 10   | 8            |
| 9    | 1            |

**🧠 Insight:**  
Order traffic peaks around **12 PM–1 PM (lunch)** and again from **5 PM–7 PM (dinner)**. These time slots represent the best windows for sales and promotions.

---

## ✅ Overall Key Takeaways

- **Friday is the top-performing day** in both order count and total revenue.
- **Saturday has the highest value per order**, suggesting more group/family purchases.
- **Lunch and early dinner hours** are the most active for orders.
- Weekdays show steady traffic, while weekends yield **fewer but higher-value** orders.