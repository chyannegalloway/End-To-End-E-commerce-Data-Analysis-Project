-- Here, I will be answering questions based aruond Product Analysis. 

-- Which product categories generate the most revenue?

WITH productjoin AS (
    SELECT 
        p.product_id, 
        pc.broader_category,
        oi.price
    FROM products_clean p
    INNER JOIN product_categories pc ON p.product_category_name = pc.product_category_name
    INNER JOIN orderitems oi ON p.product_id = oi.product_id
    ORDER BY p.product_id
)

SELECT
    broader_category,
    SUM(price) AS total_revenue
FROM productjoin
GROUP BY broader_category
ORDER BY total_revenue DESC -- hobbies generated the most revenue

-- Which categories sell the most units?

WITH productjoin AS (
    SELECT 
        p.product_id, 
        pc.broader_category,
        oi.price
    FROM products_clean p
    INNER JOIN product_categories pc ON p.product_category_name = pc.product_category_name
    INNER JOIN orderitems oi ON p.product_id = oi.product_id
    ORDER BY p.product_id
)

SELECT 
    broader_category,
    COUNT(*) AS Purchases
FROM productjoin
GROUP BY broader_category
ORDER BY Purchases DESC -- Hobbies also have the most number of sales

-- What percentage of total revenue comes from the top-perfoming products/categories?


WITH productjoin AS (
    SELECT 
        p.product_id, 
        pc.broader_category,
        oi.price
    FROM products_clean p
    INNER JOIN product_categories pc ON p.product_category_name = pc.product_category_name
    INNER JOIN orderitems oi ON p.product_id = oi.product_id
    ORDER BY p.product_id
)

SELECT 
    COUNT(*) AS Purchases
FROM productjoin
ORDER BY Purchases DESC -- 88569 total purchases

-- Which categories are growing or declining over time?

WITH product_orders AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        oi.product_id
    FROM orders o
    INNER JOIN orderitems oi ON o.order_id = oi.order_id
),

product_join_2 AS (
    SELECT 
        order_id,
        order_purchase_timestamp,
        po.product_id,
        p.product_category_name
    FROM product_orders po
    INNER JOIN products_clean p ON po.product_id = p.product_id
),

product_category_join AS (
    SELECT 
        order_purchase_timestamp,
        pj.product_id, 
        pc.broader_category
    FROM product_join_2 pj
    INNER JOIN product_categories pc ON pj.product_category_name = pc.product_category_name
)

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS Year,
 -- EXTRACT (MONTH FROM order_purchase_timestamp) AS Month,
    broader_category,
    COUNT(broader_category) AS purchases
FROM product_category_join
GROUP BY
    EXTRACT(YEAR FROM order_purchase_timestamp),
 -- EXTRACT (MONTH FROM order_purchase_timestamp),
    broader_category
ORDER BY Year
