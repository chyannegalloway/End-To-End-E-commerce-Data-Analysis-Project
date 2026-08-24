-- Here, I will be answering questions concerning Order Analysis. 

SELECT *
FROM orders

-- What percentage of orders were delivered successfully
-- number of successful/over total number x 100

SELECT 
    COUNT(order_status)
FROM orders
WHERE order_status = 'delivered' -- 87428 delivered orders

select
    COUNT(*)
FROM Orders -- 89316 delivered orders

-- percentage of orders delivered successfully = 87428/89316 x 100 = 97.89% of orders

-- how long does it take to deliver an order?

SELECT 
    order_id,
    order_purchase_timestamp,
    order_delivered_timestamp,
    EXTRACT(DAY FROM AGE(order_delivered_timestamp, order_purchase_timestamp)) AS day_diff
    -- COUNT(EXTRACT(DAY FROM AGE(order_delivered_timestamp, order_purchase_timestamp))) AS day_diff
FROM orders
WHERE order_delivered_timestamp IS NOT NULL
GROUP BY order_id;

SELECT 
    EXTRACT(DAY FROM AGE(order_delivered_timestamp, order_purchase_timestamp)) AS day_diff,
    COUNT(EXTRACT(DAY FROM AGE(order_delivered_timestamp, order_purchase_timestamp))) AS day_diff_appearances
FROM orders
WHERE order_delivered_timestamp IS NOT NULL
GROUP BY EXTRACT(DAY FROM AGE(order_delivered_timestamp, order_purchase_timestamp)) 
ORDER BY day_diff_appearances -- the majority of orders are delivered in a week, 7095 of the total number of orders. 

-- Are orders being delivered later than estimated?

SELECT
    order_id,
    order_delivered_timestamp,
    order_estimated_delivery_date
FROM Orders
WHERE order_estimated_delivery_date < order_delivered_timestamp -- AND order_delivered_timestamp IS NOT NULL -- there are orders being delivered later than estimated. 

-- What percentage of orders are being delivered late?

SELECT 
    COUNT(*)
FROM Orders -- 87427 
WHERE order_estimated_delivery_date < order_delivered_timestamp -- 6738 of the total number of orders were delivered late

SELECT COUNT(*)
FROM orders -- total number of orders
WHERE order_delivered_timestamp IS NOT NULL AND order_status = 'delivered' -- 87422 total orders delivered that were not returned NULL 

-- the percentage of orders being delivered late is: 7.71%

-- How does the order volume change over time? 

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS Year,
    EXTRACT(MONTH FROM order_purchase_timestamp) AS Month,
    COUNT(*) AS Purchases
FROM Orders
GROUP BY 
    EXTRACT(YEAR FROM order_purchase_timestamp),
    EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY Year, Month 

