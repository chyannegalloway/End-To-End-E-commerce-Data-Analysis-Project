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