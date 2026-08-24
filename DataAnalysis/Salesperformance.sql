-- Here, I will be answering questions based on Sales Performance. 

-- Analytical Dataset: 

SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
FROM Orders o
LEFT JOIN orderitems oi ON o.order_id = oi.order_id
ORDER BY o.order_id;

-- How much revenue does the business generate?

WITH salesperformance AS (
    SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
    FROM Orders o
    LEFT JOIN orderitems oi ON o.order_id = oi.order_id
    ORDER BY o.order_id
)

SELECT
    SUM(price)
FROM salesperformance -- Total revenue is 30447872.89 in whatever currency is used here. 

-- How does revenue change over time?

SELECT
    MIN(order_purchase_timestamp),
    MAX(order_purchase_timestamp)
FROM orders;

WITH salesperformance AS (
    SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
    FROM Orders o
    LEFT JOIN orderitems oi ON o.order_id = oi.order_id
    ORDER BY o.order_id
)

SELECT
    EXTRACT(YEAR FROM order_delivered_timestamp) AS year_purchased,
    SUM(Price)
FROM salesperformance
GROUP BY
    EXTRACT(YEAR FROM order_delivered_timestamp)
ORDER BY year_purchased

-- What is the month-to-month revenue growth? 

WITH salesperformance AS (
    SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
    FROM Orders o
    LEFT JOIN orderitems oi ON o.order_id = oi.order_id
    ORDER BY o.order_id
)

SELECT
    EXTRACT(YEAR FROM order_delivered_timestamp) AS year_purchased,
    EXTRACT(MONTH FROM order_delivered_timestamp) AS month_purchased,
    SUM(Price)
FROM salesperformance
GROUP BY
    EXTRACT(YEAR FROM order_delivered_timestamp),
    EXTRACT(MONTH FROM order_delivered_timestamp)
ORDER BY year_purchased, month_purchased

-- new analytical dataset

SELECT *
FROM products_clean

SELECT *
FROM product_categories

SELECT 
    products_clean.product_id, 
    products_clean.product_category_name, 
    product_categories.broader_category
FROM products_clean
LEFT JOIN product_categories ON products_clean.product_category_name = product_categories.product_category_name
ORDER BY products_clean.product_id;

SELECT
    o.order_id,
    oi.product_id,
    oi.price,
    p.product_id

-- What is the rolling 3-month/Quarterly revenue?

WITH salesperformance AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_timestamp,
        oi.price,
        oi.shipping_charges
    FROM Orders o
    LEFT JOIN orderitems oi ON o.order_id = oi.order_id
    ORDER BY o.order_id
),

quarterly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_delivered_timestamp) AS Year,
        EXTRACT(QUARTER FROM order_delivered_timestamp) AS Quarter,
        COUNT(*) AS Purchases,
        SUM(price) AS total_sales
    FROM salesperformance
    GROUP BY 
        EXTRACT(YEAR FROM order_delivered_timestamp),
        EXTRACT(QUARTER FROM order_delivered_timestamp)
    )

SELECT
    Year,
    Quarter,
    Purchases,
    total_sales,
    SUM(total_sales) OVER (ORDER BY Year, Quarter) AS cumulative_total
FROM quarterly_sales
WHERE Year IS NOT NULL AND Quarter IS NOT NULL
ORDER BY Year, Quarter;

-- How did sales compared to the previous month? 
