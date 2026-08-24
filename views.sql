-- Creating views to use in PowerBI

CREATE VIEW salesperformance_analysis AS 
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
FROM Orders o
LEFT JOIN orderitems oi ON o.order_id = oi.order_id;

CREATE VIEW customeranalysis_view AS 
SELECT
    o.order_id,
    c.customer_id,
    c.customer_city,
    p.payment_value
FROM Orders o
JOIN customers c ON o.customer_id = c.customer_id 
LEFT JOIN payments p ON o.order_id = p.order_id;

CREATE VIEW productanalysis_view AS 
  SELECT 
        p.product_id, 
        pc.broader_category,
        oi.price
    FROM products_clean p
    INNER JOIN product_categories pc ON p.product_category_name = pc.product_category_name
    INNER JOIN orderitems oi ON p.product_id = oi.product_id;

CREATE VIEW orderanalysis_view AS
SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_timestamp,
    order_estimated_delivery_date
FROM Orders