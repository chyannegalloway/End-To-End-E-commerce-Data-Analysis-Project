-- Here, I will be answering questions involving customer analysis

-- Analytical dataset

SELECT
    o.order_id,
    c.customer_id,
    c.customer_city,
    p.payment_value
FROM Orders o

JOIN customers c ON o.customer_id = c.customer_id 
LEFT JOIN payments p ON o.order_id = p.order_id

ORDER BY o.order_id;

-- How many unique customers are there?

SELECT COUNT(DISTINCT customer_id)
FROM customers -- There are 89316 unique customers in the dataset. 

-- What is the average order value?

WITH customer_analysis AS (
    SELECT
    o.order_id,
    c.customer_id,
    c.customer_city,
    p.payment_value
    FROM Orders o

    JOIN customers c ON o.customer_id = c.customer_id 
    LEFT JOIN payments p ON o.order_id = p.order_id

    ORDER BY o.order_id
)

SELECT 
    ROUND(AVG(payment_value), 2)
FROM customer_analysis -- Average order value is 268.66

-- Where are the most orders coming from, which city?

SELECT 
    customer_city,
    COUNT(customer_city) AS appearances
FROM customers -- 3735 unique customer cities
GROUP BY 
    DISTINCT(customer_city)
ORDER BY appearances DESC -- Sao Paulo has the most number of orders at 14352 orders, followed by Rio de Janeiro at 6248. This makes sense as Sao Paulo is the most populous city in Brazil. 