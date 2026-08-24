-- cleaning Orders table

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

-- Cleaning the OrderItems table

SELECT *
FROM orderitems;

SELECT
    order_id,
    COUNT(*)
FROM orderitems
GROUP BY order_id
HAVING COUNT(*) > 1; -- There are no duplicates here. 

SELECT *
FROM orderitems
WHERE
    order_id IS NULL OR
    product_id IS NULL OR
    seller_id IS NULL OR
    price IS NULL OR 
    shipping_charges IS NULL -- There are no NULL values in this table. 

SELECT
    price,
    shipping_charges
FROM orderitems
WHERE 
    price < 0 OR shipping_charges < 0 -- There are no negative/impossible prices or shipping charges in this dataset. 

SELECT 
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    MIN(shipping_charges) AS minimum_shipping,
    MAX(shipping_charges) AS maximum_shipping
FROM orderitems; -- The min values here seem reasonable. For the max values, I will do further inspection. 

SELECT *
FROM orderitems
WHERE 
    price = '6735.00' OR 
    shipping_charges = '409.68' -- further inspection needs to be done here, through joins to determine other aspects of the product that would have required such a high shipping charge. The currency is Brazilian Real, so perhaps I need to consider the exchange rate. 


-- Cleaning Customers Table

SELECT *
FROM customers

SELECT
    customer_id,
    COUNT(*)
from customers
GROUP BY customer_id
HAVING COUNT(*) > 1; -- there are no duplicate values here

SELECT *
FROM customers
WHERE 
    customer_id IS NULL OR
    customer_zip_code_prefix IS NULL OR
    customer_city IS NULL OR 
    customer_state IS NULL -- no NULL values in this table. 

SELECT DISTINCT customer_city
FROM customers -- maybe clean the customer city so the cities are properly capitalised. 

-- Cleaning Payments Table

SELECT *
FROM payments

SELECT
    order_id,
    COUNT(*)
FROM payments
GROUP BY order_id
HAVING COUNT(*) > 1; -- there are no duplicate values here

SELECT *
FROM payments
WHERE 
    order_id IS NULL OR 
    payment_sequential IS NULL OR 
    payment_type IS NULL OR 
    payment_installments IS NULL OR 
    payment_value IS NULL -- there are no NULL values

SELECT *
FROM Payments
WHERE 
    payment_sequential < 0 OR 
    payment_installments < 0 OR 
    payment_value < 0 -- no impossible data values

SELECT DISTINCT payment_type
FROM payments -- distinct payment values are reasonable. 

SELECT 
    MIN(payment_value),
    MAX(payment_value),
    MIN(payment_sequential),
    MAX(payment_sequential),
    MIN(payment_installments),
    MAX(payment_installments)
FROM payments -- largest payment value is 7247.88 Brazilian Real 

-- Cleaning Products Table

SELECT 
    product_id,
    COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1; 

-- the Products table contains duplicates, some further investigation is needed.

SELECT *
FROM products
WHERE product_id = 'EurJYuMniSRE' or product_id = '0eSlsvSF9ddD'
ORDER BY product_id;

SELECT *
FROM products
WHERE product_id = 'wOXCQyEa84Wo'
ORDER BY product_id;

SELECT COUNT (*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM products; -- for 89316 total rows there are only 27451 unique product ids.


-- from this investigation, I can determine that these are true duplicate values. Now, I need to find out whether these duplicate values need to be deleted, or they are valid data values. 

SELECT product_id,
    COUNT(*) Occurrences
FROM products
GROUP BY product_id
ORDER BY occurrences DESC
LIMIT 20; -- this returns a table listing how frequently products are repeated

SELECT COUNT(DISTINCT product_id) AS unique_products,
    COUNT(*) AS total_rows
FROM products;

-- checking other tables

SELECT product_id,
    COUNT(*) Occurrences
FROM orderitems
GROUP BY product_id
ORDER BY occurrences DESC
LIMIT 20; -- the same occurrences show up on the orderitems table for the product_ids

-- Because of this, I can determine that these duplicate values are not a problem with the dataset. 
SELECT 
    product_id,
    COUNT(*) AS occurrences,
    COUNT(DISTINCT product_category_name) AS different_categories,
    COUNT(DISTINCT product_weight_g) AS different_weights,
    COUNT(DISTINCT product_length_cm) AS different_lengths,
    COUNT(DISTINCT product_height_cm) AS different_heights,
    COUNT(DISTINCT product_width_cm) AS different_widths
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- this returns a table which tells me that the duplicate product_ids are identical records. Now, I mean to clean the products table so there is only one row per product id. 

CREATE TABLE products_clean AS 
SELECT DISTINCT *
FROM products;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM products_clean

ALTER TABLE products_clean
ADD PRIMARY KEY (product_id);

-- This analysis is a result of me mistakenly forgetting to add the product_id column as the primary key in my initial table creation. I have chosen to keep this step of my analysis in the final showing of my code because I wish to demonstrate how I was able to recognise my mistake, while also

SELECT *
FROM products
WHERE 
    product_id IS NULL OR 
    product_category_name IS NULL OR 
    product_weight_g IS NULL OR 
    product_length_cm IS NULL OR 
    product_height_cm IS NULL OR 
    product_width_cm IS NULL -- there are numerous NULL values in this table. 

SELECT
    product_category_name
FROM Products
WHERE product_category_name IS NULL 



-- Checking IDs connect between tables

SELECT DISTINCT oi.product_id
FROM orderitems oi
LEFT JOIN products_clean p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL; -- checks if the relationship between orderitems and products works correctly through a JOIN



