# 📊 06 – Top Ingredients in Best-Selling Pizzas

This report analyzes ingredient performance across different dimensions to identify which ingredients contribute most to pizza sales and revenue. The analysis is based on the following aspects:

1. **Popularity (Used in Most Pizza Types)**
2. **Total Quantity Sold**
3. **Total Revenue Generated**
4. **Average Revenue per Pizza**
5. **Presence in Top 10 Best-Selling Pizzas**


---
## ✅ Step 1: Top Ingredients by Frequency (Across All Pizzas)

We need to split ingredients (which are stored as comma-separated values) and count their frequency across all pizzas.

Uses JSON_TABLE to split ingredients — much faster and cleaner than SUBSTRING_INDEX loops.

```sql
WITH exploded_ingredients AS (
    SELECT 
        pt.pizza_type_id,
        TRIM(ingredient) AS ingredient
    FROM 
        pizza_types pt,
        JSON_TABLE(
            CONCAT('["', REPLACE(pt.ingredients, ', ', '","'), '"]'),
            '$[*]' COLUMNS (ingredient VARCHAR(255) PATH '$')
        ) AS jt
)
SELECT 
    ingredient,
    COUNT(DISTINCT pizza_type_id) AS pizza_count
FROM 
    exploded_ingredients
GROUP BY 
    ingredient
ORDER BY 
    pizza_count DESC;
```
### 🥇 1. Most Frequently Used Ingredients in Pizza Types

| Ingredient         | Pizza Count |
|--------------------|-------------|
| Garlic             | 20          |
| Tomatoes           | 18          |
| Red Onions         | 13          |
| Red Peppers        | 10          |
| Spinach            | 8           |
| Mushrooms          | 7           |
| Pepperoni          | 6           |
| Mozzarella Cheese  | 6           |
| Artichokes         | 5           |
| Chicken            | 5           |

**🔍 Insight:**  
Garlic and Tomatoes are the most widely used ingredients, appearing in 20 and 18 different pizza types respectively. These ingredients form the foundational base for a large part of the menu and offer flexibility in flavor combinations.


---
## ✅ Step 2: Top Ingredients by Total Quantity Sold

Join exploded ingredients with sales data.

📊 Gives most-used ingredients based on actual order quantities.

```sql
WITH exploded_ingredients AS (
    SELECT 
        pt.pizza_type_id,
        TRIM(ingredient) AS ingredient
    FROM 
        pizza_types pt,
        JSON_TABLE(
            CONCAT('["', REPLACE(pt.ingredients, ', ', '","'), '"]'),
            '$[*]' COLUMNS (ingredient VARCHAR(255) PATH '$')
        ) AS jt
),
ingredient_sales AS (
    SELECT 
        ei.ingredient,
        SUM(od.quantity) AS total_quantity_sold
    FROM 
        exploded_ingredients ei
    JOIN 
        pizza p ON ei.pizza_type_id = p.pizza_type_id
    JOIN 
        order_details od ON od.pizza_id = p.pizza_id
    GROUP BY 
        ei.ingredient
)
SELECT * FROM ingredient_sales
ORDER BY total_quantity_sold DESC
LIMIT 20;
```

### 📦 2. Ingredients by Total Quantity Sold

| Ingredient         | Total Quantity Sold |
|--------------------|---------------------|
| Garlic             | 27,913              |
| Tomatoes           | 27,052              |
| Red Onions         | 19,834              |
| Red Peppers        | 16,562              |
| Mozzarella Cheese  | 10,569              |
| Pepperoni          | 10,540              |
| Spinach            | 10,166              |
| Mushrooms          | 9,729               |
| Chicken            | 8,618               |
| Capocollo          | 6,692               |

**🔍 Insight:**  
Garlic and Tomatoes again top the list in terms of total quantity sold, reinforcing their central role in the best-selling pizzas. Ingredients like Pepperoni, Mozzarella Cheese, and Chicken also emerge as crowd favorites.


---

## ✅ Step 3: Top Ingredients by Revenue Generated

💰 Shows which ingredients contribute most to overall revenue.

```sql
WITH exploded_ingredients AS (
    SELECT 
        pt.pizza_type_id,
        TRIM(ingredient) AS ingredient
    FROM 
        pizza_types pt,
        JSON_TABLE(
            CONCAT('["', REPLACE(pt.ingredients, ', ', '","'), '"]'),
            '$[*]' COLUMNS (ingredient VARCHAR(255) PATH '$')
        ) AS jt
),
ingredient_revenue AS (
    SELECT 
        ei.ingredient,
        ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
    FROM 
        exploded_ingredients ei
    JOIN 
        pizza p ON ei.pizza_type_id = p.pizza_type_id
    JOIN 
        order_details od ON od.pizza_id = p.pizza_id
    GROUP BY 
        ei.ingredient
)
SELECT * FROM ingredient_revenue
ORDER BY total_revenue DESC
LIMIT 20;
```
### 💰 3. Ingredients by Total Revenue Contribution

| Ingredient         | Total Revenue ($) |
|--------------------|-------------------|
| Garlic             | 484,124.30        |
| Tomatoes           | 467,960.85        |
| Red Onions         | 339,571.60        |
| Red Peppers        | 284,959.25        |
| Spinach            | 165,947.25        |
| Mozzarella Cheese  | 161,386.20        |
| Chicken            | 153,151.50        |
| Mushrooms          | 151,942.75        |
| Pepperoni          | 150,951.50        |
| Capocollo          | 118,931.00        |

**🔍 Insight:**  
From a revenue standpoint, Garlic and Tomatoes generate nearly half a million dollars each, proving their profitability. Ingredients like Chicken and Mozzarella Cheese offer both popularity and premium revenue performance.


----

## ✅ Step 4: Average Revenue per Pizza Containing Ingredient

This helps find premium ingredients.

🧠 This reveals high-margin ingredients even if they’re not used frequently.

```sql
WITH exploded_ingredients AS (
    SELECT 
        pt.pizza_type_id,
        TRIM(ingredient) AS ingredient
    FROM 
        pizza_types pt,
        JSON_TABLE(
            CONCAT('["', REPLACE(pt.ingredients, ', ', '","'), '"]'),
            '$[*]' COLUMNS (ingredient VARCHAR(255) PATH '$')
        ) AS jt
),
ingredient_avg_revenue AS (
    SELECT 
        ei.ingredient,
        ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT p.pizza_id), 2) AS avg_revenue_per_pizza
    FROM 
        exploded_ingredients ei
    JOIN 
        pizza p ON ei.pizza_type_id = p.pizza_type_id
    JOIN 
        order_details od ON od.pizza_id = p.pizza_id
    GROUP BY 
        ei.ingredient
)
SELECT * FROM ingredient_avg_revenue
ORDER BY avg_revenue_per_pizza DESC
LIMIT 20;
```

### 📈 4. Ingredients by Average Revenue per Pizza

| Ingredient                   | Avg Revenue per Pizza ($) |
|------------------------------|----------------------------|
| Romano Cheese                | 26,066.50                  |
| Provolone Cheese             | 26,066.50                  |
| Smoked Gouda Cheese          | 26,066.50                  |
| Blue Cheese                  | 26,066.50                  |
| Italian Sausage              | 22,968.00                  |
| Chorizo Sausage              | 22,968.00                  |
| Ricotta Cheese               | 16,132.85                  |
| Parmigiano Reggiano Cheese  | 16,132.85                  |
| Gorgonzola Piccante Cheese  | 16,132.85                  |
| Bacon                        | 15,287.13                  |

**🔍 Insight:**  
Rare or specialty cheeses and meats such as Romano Cheese, Provolone, and Italian Sausage command high average revenue per pizza, suggesting they are used in premium-priced offerings. These can be strategically promoted to drive high-margin sales.

---
## ✅ Step 5: Top 10 Ingredients in Best-Selling Pizzas Only

📈 Pinpoints ingredients commonly found in top sellers — helps drive ingredient-based bundling or marketing.


```sql
WITH top_pizzas AS (
    SELECT 
        od.pizza_id,
        SUM(od.quantity) AS total_sold
    FROM 
        order_details od
    GROUP BY 
        od.pizza_id
    ORDER BY total_sold DESC
    LIMIT 10
),
top_pizza_types AS (
    SELECT 
        DISTINCT p.pizza_type_id
    FROM 
        top_pizzas tp
    JOIN 
        pizza p ON tp.pizza_id = p.pizza_id
),
exploded_ingredients AS (
    SELECT 
        pt.pizza_type_id,
        TRIM(ingredient) AS ingredient
    FROM 
        pizza_types pt,
        JSON_TABLE(
            CONCAT('["', REPLACE(pt.ingredients, ', ', '","'), '"]'),
            '$[*]' COLUMNS (ingredient VARCHAR(255) PATH '$')
        ) AS jt
)
SELECT 
    ei.ingredient,
    COUNT(DISTINCT ei.pizza_type_id) AS top_pizza_usage
FROM 
    exploded_ingredients ei
JOIN 
    top_pizza_types tp ON ei.pizza_type_id = tp.pizza_type_id
GROUP BY 
    ei.ingredient
ORDER BY 
    top_pizza_usage DESC
LIMIT 10;
```

### 🏆 5. Ingredients in Top 10 Best-Selling Pizzas

| Ingredient         | Top Pizza Usage |
|--------------------|-----------------|
| Red Peppers        | 4               |
| Tomatoes           | 4               |
| Red Onions         | 3               |
| Mozzarella Cheese  | 3               |
| Garlic             | 3               |
| Bacon              | 2               |
| Pineapple          | 2               |
| Pepperoni          | 2               |
| Chicken            | 2               |
| Artichokes         | 1               |

**🔍 Insight:**  
Top-sellers feature a consistent presence of ingredients like Tomatoes, Red Peppers, Mozzarella, and Garlic. These should be maintained as staples. Ingredients like Bacon, Pineapple, and Pepperoni are also common among the highest performers, indicating their strong appeal.


---

## 📌 Final Summary & Business Insights

- **Core Ingredients**: 

    Garlic, Tomatoes, and Mozzarella Cheese are not only the most used but also among the highest in sales and revenue. They should remain central to the menu.
- **High-Margin Ingredients**: 

    Specialty cheeses and premium meats (e.g., Romano, Smoked Gouda, Italian Sausage) offer high average revenue per pizza. These can be promoted through gourmet or seasonal pizza campaigns.
- **Customer Favorites**: 

    Ingredients like Red Onions, Red Peppers, and Pepperoni appear frequently in top-performing pizzas, confirming their mass appeal.
- **Strategic Menu Design**:

  - Use a mix of top-performing and high-margin ingredients to balance volume and profitability.
  - Consider bundling or upselling pizzas with premium ingredients.
  - Promote pizzas with high-appeal ingredients via offers or combo deals.

✅ **Next Step**: 

- This analysis can guide inventory planning, marketing campaigns, and seasonal promotions by focusing on ingredient-driven performance.