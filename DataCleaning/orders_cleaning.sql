SELECT
    order_id,
    COUNT(*)
FROM Orders
GROUP BY order_id
HAVING COUNT(*) > 1; -- there are no duplicate values here


SELECT *
FROM orders
WHERE customer_id IS NULL OR
     order_status IS NULL OR
      order_purchase_timestamp IS NULL OR 
      order_approved_at IS NULL OR 
      order_delivered_timestamp IS NULL OR 
      order_estimated_delivery_date IS NULL;
-- there are NULL values here, mostly in the order_delivered_timestamp column.

SELECT
    COUNT(*)
FROM orders
WHERE order_delivered_timestamp IS NULL -- there are 1889 NULL values in the order_delivered_timestamp column 

SELECT
    order_status,
    COUNT(*) AS orders_without_delivery
FROM Orders
WHERE order_delivered_timestamp IS NULL
GROUP BY order_status
ORDER BY orders_without_delivery DESC; 
-- this shows the relationship between the NULL values in orders delivered timestamp and the order status. 
-- the table showed that the majority of NULL values were shipped orders. There were 6 orders that were delivered but do not have a delivery date. 

-- now, inspecting the 6 delivered NULL values
SELECT 
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_timestamp,
    order_estimated_delivery_date
FROM orders
WHERE order_delivered_timestamp IS NULL AND order_status = 'delivered'
-- there is no consistent pattern as to why these order deliveries were returned NULL, therefore there must have been insufficient information to accurately determine the actual delivery date for these orders. 

SELECT *
FROM Orders
WHERE order_approved_at IS NULL; -- there are 9 NULL values in the order_approved_at column. They were all delivered, and have no consistancies in the timestamp columns. Therefore, again, there simply must have been insufficient information to complete these rows. 

-- checking for invalid values. 

SELECT DISTINCT order_status
FROM Orders;

SELECT 
    order_purchase_timestamp,
    order_approved_at
FROM Orders
WHERE order_purchase_timestamp > order_approved_at -- There is no data here, the order dates are valid

SELECT
    order_purchase_timestamp,
    order_delivered_timestamp
FROM Orders
WHERE order_purchase_timestamp > order_delivered_timestamp -- no data here, the dates are valid. 

SELECT
    MIN(order_purchase_timestamp),
    MAX(order_purchase_timestamp),
    MIN(order_approved_at),
    MAX(order_approved_at),
    MIN(order_delivered_timestamp),
    MAX(order_delivered_timestamp)
FROM Orders; -- The dates are all within an acceptable range. 