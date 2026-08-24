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