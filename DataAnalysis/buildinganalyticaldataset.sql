-- I am going to use joins to combine the tables and build the dataset I want to work with in order to answer various business questions. 

/*
For Sales Performance analysis
    - Order: order_id, order_purchased_date, order_delivered
    - OrderItems: price, shipping_charges
*/

SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
FROM Orders o
LEFT JOIN orderitems oi ON o.order_id = oi.order_id
ORDER BY o.order_id;

/*
For Customer analysis
    - Orders: order_id, customer_id
    - Customers: customer_id, customer_city
    - Payments: order_id, payment_value
*/

SELECT
    o.order_id,
    c.customer_id,
    c.customer_city,
    p.payment_value
FROM Orders o

JOIN customers c ON o.customer_id = c.customer_id 
LEFT JOIN payments p ON o.order_id = p.order_id

ORDER BY o.order_id;

/*
For Product analysis
    - Orders: order_id
    - OrderItems: order_id, product_id
    - Products: product_id, product_category_name
    - Productcategories: product_category_name, broader_category (ALL)
*/

SELECT
    o.order_id,
    oi.product_id,
    p.product_category_name,
    pc.broader_category
FROM Orders o 
JOIN orderitems oi ON o.order_id = oi.order_id

-- don't know how to JOIN these yet. 
