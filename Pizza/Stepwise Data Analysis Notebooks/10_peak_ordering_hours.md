# 📊 10_Peak_Ordering_Hours Analysis


✅ Core Objective

To identify when customers place the most orders, and analyze patterns based on hours of the day, day of the week, and order volume, including:
- Hourly distribution
- Day + hour interaction
- Revenue vs quantity correlation
- Operational load windows

---

## ⏰ 1.Orders by Hour

```sql
SELECT 
    HOUR(time) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;
```

| order_hour | total_orders |
|------------|--------------|
| 9          | 1            |
| 10         | 8            |
| 11         | 1231         |
| 12         | 2520         |
| 13         | 2455         |
| 14         | 1472         |
| 15         | 1468         |
| 16         | 1920         |
| 17         | 2336         |
| 18         | 2399         |
| 19         | 2009         |
| 20         | 1642         |
| 21         | 1198         |
| 22         | 663          |
| 23         | 28           |

**🧠 Insight:**  
- Order volume starts building around 11 AM.  
- Peaks occur during 12 PM–1 PM and 5 PM–7 PM.  
- Minimal orders are placed before 10 AM and after 10 PM.  

---

## 🍕 2.Quantity Ordered by Hour

```sql
SELECT 
    HOUR(o.time) AS order_hour,
    SUM(od.quantity) AS total_quantity
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_hour
ORDER BY order_hour;
```

| order_hour | total_quantity |
|------------|----------------|
| 9          | 4              |
| 10         | 18             |
| 11         | 2728           |
| 12         | 6776           |
| 13         | 6413           |
| 14         | 3613           |
| 15         | 3216           |
| 16         | 4239           |
| 17         | 5211           |
| 18         | 5417           |
| 19         | 4406           |
| 20         | 3534           |
| 21         | 2545           |
| 22         | 1386           |
| 23         | 68             |

**🧠 Insight:**  
- The largest number of pizzas are sold between 12 PM–1 PM and 5 PM–7 PM.  
- Indicates bulk/larger orders in those peak windows.  

---

## 📅 3.Day-Hour Order Distribution

```sql
SELECT 
    DAYNAME(o.date) AS day_name,
    HOUR(o.time) AS hour,
    COUNT(*) AS total_orders
FROM orders o
GROUP BY day_name, hour
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), hour;
```

| day_name | hour | total_orders |
|----------|------|---------------|
| Monday   | 10   | 1             |
| Monday   | 11   | 226           |
| Monday   | 12   | 398           |
| Monday   | 13   | 331           |
| Monday   | 14   | 182           |
| Monday   | 15   | 192           |
| Monday   | 16   | 247           |
| Monday   | 17   | 317           |
| Monday   | 18   | 303           |
| Monday   | 19   | 235           |
| Monday   | 20   | 174           |
| Monday   | 21   | 134           |
| Monday   | 22   | 53            |
| Monday   | 23   | 1             |
| Tuesday  | 9    | 1             |
| Tuesday  | 11   | 188           |
| Tuesday  | 12   | 421           |
| Tuesday  | 13   | 371           |
| Tuesday  | 14   | 196           |
| Tuesday  | 15   | 191           |
| Tuesday  | 16   | 295           |
| Tuesday  | 17   | 309           |
| Tuesday  | 18   | 301           |
| Tuesday  | 19   | 274           |
| Tuesday  | 20   | 214           |
| Tuesday  | 21   | 131           |
| Tuesday  | 22   | 81            |
| Wednesday| 10   | 2             |
| Wednesday| 11   | 231           |
| Wednesday| 12   | 420           |
| Wednesday| 13   | 381           |
| Wednesday| 14   | 201           |
| Wednesday| 15   | 210           |
| Wednesday| 16   | 259           |
| Wednesday| 17   | 343           |
| Wednesday| 18   | 335           |
| Wednesday| 19   | 238           |
| Wednesday| 20   | 193           |
| Wednesday| 21   | 139           |
| Wednesday| 22   | 72            |
| Thursday | 10   | 3             |
| Thursday | 11   | 214           |
| Thursday | 12   | 434           |
| Thursday | 13   | 438           |
| Thursday | 14   | 233           |
| Thursday | 15   | 228           |
| Thursday | 16   | 289           |
| Thursday | 17   | 376           |
| Thursday | 18   | 361           |
| Thursday | 19   | 270           |
| Thursday | 20   | 217           |
| Thursday | 21   | 114           |
| Thursday | 22   | 60            |
| Thursday | 23   | 2             |
| Friday   | 11   | 192           |
| Friday   | 12   | 415           |
| Friday   | 13   | 413           |
| Friday   | 14   | 221           |
| Friday   | 15   | 190           |
| Friday   | 16   | 258           |
| Friday   | 17   | 344           |
| Friday   | 18   | 387           |
| Friday   | 19   | 340           |
| Friday   | 20   | 319           |
| Friday   | 21   | 268           |
| Friday   | 22   | 180           |
| Friday   | 23   | 11            |
| Saturday | 10   | 1             |
| Saturday | 11   | 85            |
| Saturday | 12   | 222           |
| Saturday | 13   | 260           |
| Saturday | 14   | 225           |
| Saturday | 15   | 235           |
| Saturday | 16   | 294           |
| Saturday | 17   | 325           |
| Saturday | 18   | 388           |
| Saturday | 19   | 371           |
| Saturday | 20   | 328           |
| Saturday | 21   | 265           |
| Saturday | 22   | 147           |
| Saturday | 23   | 12            |
| Sunday   | 10   | 1             |
| Sunday   | 11   | 95            |
| Sunday   | 12   | 210           |
| Sunday   | 13   | 261           |
| Sunday   | 14   | 214           |
| Sunday   | 15   | 222           |
| Sunday   | 16   | 278           |
| Sunday   | 17   | 322           |
| Sunday   | 18   | 324           |
| Sunday   | 19   | 281           |
| Sunday   | 20   | 197           |
| Sunday   | 21   | 147           |
| Sunday   | 22   | 70            |
| Sunday   | 23   | 2             |

**🧠 Insight:**  
- Consistent weekday ordering patterns: spikes around lunch and dinner.  
- Weekends show more **even distribution** throughout the afternoon and evening.  
- Saturday and Sunday evenings (5 PM–9 PM) remain strong performers.  

---

## 💸 4.Peak Hours by Revenue

```sql
SELECT 
    HOUR(o.time) AS order_hour,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizza p ON od.pizza_id = p.pizza_id
GROUP BY order_hour
ORDER BY total_revenue DESC
LIMIT 5;
```

| order_hour | total_revenue |
|------------|----------------|
| 12         | 111,877.90     |
| 13         | 106,065.70     |
| 18         | 89,296.85      |
| 17         | 86,237.45      |
| 19         | 72,628.90      |

**🧠 Insight:**  
- Highest revenue hours are around **12 PM–1 PM** and **5 PM–7 PM**.  
- Lunch and dinner periods are not only order-heavy but also high-value.  

---

## 🔄 Operational Load by Time Bucket

| load_window | total_orders |
|-------------|--------------|
| High Load   | 12,972       |
| Mid Load    | 7,686        |
| Low Load    | 692          |

**🧠 Insight:**  
- 3 PM–9 PM is the **critical high-load window**.  
- Morning (before 10 AM) and late-night (after 10 PM) are nearly negligible.  