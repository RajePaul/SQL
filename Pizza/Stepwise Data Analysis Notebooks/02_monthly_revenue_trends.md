# 📊 Monthly Revenue Trends Analysis

This analysis explores revenue patterns on a **monthly basis** to uncover trends, average order values, category performance, and growth rates. Such insights help businesses plan seasonal promotions, manage inventory, and understand demand fluctuations.

---

## 🧮 Query 1: Total Monthly Revenue

```sql
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity * p.price), 2) AS monthly_revenue
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    month
ORDER BY 
    month;
```

### ✅ 1. Total Monthly Revenue

**Query**: Aggregates monthly revenue using total quantity × price.

| 📅 Month | 💰 Revenue |
|---------|------------|
| January | ₹69,793.30 |
| February | ₹65,159.60 |
| March | ₹70,397.10 |
| April | ₹68,736.80 |
| May | ₹71,402.75 |
| June | ₹68,230.20 |
| July | **₹72,557.90** |
| August | ₹68,278.25 |
| September | ₹64,180.05 |
| October | ₹64,027.60 |
| November | ₹70,395.35 |
| December | ₹64,701.15 |

**Insight**:
- Revenue peaks in **July** and **May**.
- Lowest revenue in **October** and **September**.

**Business Implication**:
- Plan **promotions** in low-revenue months (Sep–Oct).
- **Scale operations** (inventory, staff) in high months (May–Jul).

---

## 📦 Query 2: Average Order Value Per Month

```sql
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
GROUP BY 
    month
ORDER BY 
    month;
```
### ✅ 2. Average Order Value (AOV) Per Month

**Query**: To find the average order value per month, i.e.,
how much revenue each order generates on average, month by month.

| 📅 Month | 📦 Avg Order Value |
|---------|---------------------|
| January | ₹37.83 |
| February | ₹38.67 |
| March | ₹38.26 |
| April | ₹38.21 |
| May | ₹38.53 |
| June | ₹38.48 |
| July | ₹37.50 |
| August | ₹37.09 |
| September | ₹38.64 |
| October | ₹38.90 |
| November | **₹39.28** |
| December | ₹38.51 |

**Insight**:
- AOV is **stable**: ₹37.09 – ₹39.28.
- **November** has the highest AOV.

**Business Implication**:
- Pricing strategy appears **consistent**.
- Target **upselling/cross-selling** in low AOV months like August.

---

## 🍕 Query 3: Monthly Revenue by Pizza Category

```sql
SELECT 
    DATE_FORMAT(o.date, '%Y-%m') AS month,
    pt.category,
    ROUND(SUM(od.quantity * p.price), 2) AS category_revenue
FROM 
    orders o
JOIN 
    order_details od ON o.order_id = od.order_id
JOIN 
    pizza p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    month, pt.category
ORDER BY 
    month, category_revenue DESC;
```
### ✅ 3. Monthly Revenue by Pizza Category

**Query**: Revenue grouped by month and pizza category.

**Key Insights**:
- **Classic** pizzas are top sellers in every month.
- **Chicken** and **Supreme** categories compete for 2nd and 3rd spots.
- **Veggie** consistently contributes the least revenue.

**Sample from January**:

| Category | Revenue |
|----------|---------|
| Classic | ₹18,619.40 |
| Supreme | ₹17,929.75 |
| Veggie | ₹17,055.40 |
| Chicken | ₹16,188.75 |

**Business Implication**:
- Focus on **Classic** category for revenue stability.
- Consider **promotions** or **combos** for Veggie and Chicken pizzas to boost their contribution.



---

## 📈 Query 4: Month-over-Month Growth Rate
```sql
WITH monthly_rev AS (
    SELECT 
        DATE_FORMAT(o.date, '%Y-%m') AS month,
        SUM(od.quantity * p.price) AS revenue
    FROM 
        orders o
    JOIN 
        order_details od ON o.order_id = od.order_id
    JOIN 
        pizza p ON od.pizza_id = p.pizza_id
    GROUP BY 
        month
)
SELECT 
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS mom_growth_percent
FROM 
    monthly_rev;
```


### ✅ 4. Month-over-Month (MoM) Growth Rate

**Query**: Revenue percentage change from previous month using window function.

| 📅 Month | 💰 Revenue | 📈 MoM Growth (%) |
|---------|------------|-------------------|
| January | ₹69,793.30 | – |
| February | ₹65,159.60 | -6.64% |
| March | ₹70,397.10 | +8.04% |
| April | ₹68,736.80 | -2.36% |
| May | ₹71,402.75 | +3.88% |
| June | ₹68,230.20 | -4.44% |
| July | ₹72,557.90 | +6.34% |
| August | ₹68,278.25 | -5.90% |
| September | ₹64,180.05 | -6.00% |
| October | ₹64,027.60 | -0.24% |
| November | ₹70,395.35 | **+9.95%** |
| December | ₹64,701.15 | -8.09% |

**Insight**:
- Strong growth in **March**, **July**, and **November**.
- Steep decline in **December**, despite holiday season.

**Business Implication**:
- Investigate **December drop** — missed opportunity?
- Use **growth months** to test new products or campaigns.
- Consider proactive campaigns during expected downturns (Feb, Sep).
---

## 🧠 Final Takeaways

- **May, July, and November** are top-performing months — ideal for new launches and customer rewards.
- **Classic** pizzas are the revenue anchor — optimize marketing and inventory accordingly.
- **Veggie and Chicken** need targeted strategies to increase market share.
- Leverage **MoM growth trends** to forecast, plan promotions, and align logistics.

---
