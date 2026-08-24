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