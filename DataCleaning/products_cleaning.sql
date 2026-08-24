-- First, checking for duplicate values. 

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
FROM products_clean
WHERE 
    product_id IS NULL OR 
    product_category_name IS NULL OR 
    product_weight_g IS NULL OR 
    product_length_cm IS NULL OR 
    product_height_cm IS NULL OR 
    product_width_cm IS NULL -- there are numerous NULL values in this table. 

SELECT COUNT(*)
FROM products_clean
WHERE product_category_name IS NULL -- there are 141 NULL values in the product_category_name, 2 NULL dimension columns. In each row, either all of the dimensions are known, or none of the dimensions are known. 

SELECT 
    product_category_name,
    product_weight_g
FROM products_clean
WHERE product_weight_g IS NULL -- when the dimensions are NULL, the product category is 'toys'. 

SELECT COUNT(DISTINCT product_category_name)
FROM products_clean -- there are a large number of product categories, I will now group them together by creating a mapping table, then joining. 

CREATE TABLE product_categories (
    product_category_name VARCHAR(500),
    broader_category VARCHAR(500)
)

INSERT INTO product_categories (product_category_name, broader_category)
VALUES 
    ('industry_commerce_and_business', 'Misc'),
    ('diapers_and_hygiene', 'Misc' ),
    ('fashion_shoes', 'Fashion'),
    ('home_appliances', 'Home'),
    ('fashion_sport', 'Fashion'),
    ('small_appliances', 'Home'), 
    ('health_beauty', 'Beauty'),
    ('toys', 'Hobbies'),
    ('fashion_underwear_beach', 'Fashion'),
    ('drinks', 'Misc'),
    ('dvds_blu_ray', 'Electronics'),
    ('construction_tools_construction', 'Tools'),
    ('agro_industry_and_commerce', 'Misc'),
    ('arts_and_craftmanship', 'Hobbies'),
    ('books_general_interest', 'Hobbies'),
    ('fixed_telephony', 'Electronics'),
    ('security_and_services', 'Services'),
    ('costruction_tools_garden', 'Tools'),
    ('consoles_games', 'Hobbies'),
    ('computers_accessories', 'Electronics'),
    ('bed_bath_table', 'Home'),
    ('tablets_printing_image', 'Electronics'),
    ('party_supplies', 'Misc'),
    ('la_cuisine', 'Misc'),
    ('fashion_bags_acessories', 'Fashion'),
    ('garden_tools', 'Tools'), 
    ('constrution_tools_safety', 'Tools'),
    ('luggage_accessories', 'Misc'),
    ('construction_tools_lights', 'Tools'),
    ('furniture_mattress_and_upholstery', 'Home'),
    ('kitchen_dining_laundry_garden_furniture', 'Home'),
    ('housewares', 'Home'),
    ('small_appliances_home_oven_and_coffee', 'Home'),
    ('art', 'Misc'),
    ('fashio_female_clothing', 'Fashion'),
    ('home_appliances_2', 'Home'),
    ('baby', 'Misc'),
    ('food', 'Misc'),
    ('fashion_childrens_clothes', 'Fashion'),
    ('books_technical', 'Hobbies'),
    ('home_confort', 'Home'),
    ('market_place', 'Misc'),
    ('stationery', 'Home'),
    ('furniture_living_room', 'Home'),
    ('costruction_tools_tools', 'Tools'),
    ('audio', 'Electronics'),
    ('watches_gifts', 'Electronics'),
    ('furniture_bedroom', 'Home'),
    ('cool_stuff', 'Misc'),
    ('computers', 'Electronics'),
    ('fashion_male_clothing', 'Fashion'),
    ('perfumery', 'Beauty'),
    ('signaling_and_security', 'Misc'),
    ('books_imported', 'Hobbies'),
    ('air_conditioning', 'Electronics'),
    ('pet_shop', 'Misc'),
    ('office_furniture', 'Home'),
    ('home_comfort_2', 'Home'),
    ('food_drink', 'Misc'),
    ('furniture_decor', 'Home'),
    ('electronics', 'Electronics'),
    ('musical_instruments', 'Hobbies'),
    ('cine_photo', 'Hobbies'),
    ('sports_leisure', 'Hobbies'),
    ('telephony', 'Electronics'),
    ('flowers', 'Misc'),
    ('home_construction', 'Home'),
    ('auto', 'Misc'),
    ('christmas_supplies', 'Misc'),
    ('Music', 'Hobbies'),
    (NULL, 'Unknown');

SELECT *
FROM products_clean

SELECT products_clean.product_id, products_clean.product_category_name, product_categories.broader_category
FROM products_clean
LEFT JOIN product_categories ON products_clean.product_category_name = product_categories.product_category_name
ORDER BY products_clean.product_id;