CREATE TABLE Orders (
    order_id VARCHAR(500) PRIMARY KEY,
    customer_id VARCHAR(500),
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_timestamp TIMESTAMP,
    order_estimated_delivery_date DATE
);

CREATE TABLE OrderItems (
    order_id VARCHAR(500) PRIMARY KEY,
    product_id VARCHAR(500),
    seller_id VARCHAR (500),
    price INT,
    shipping_charges INT
);

CREATE TABLE Customers (
    customer_id VARCHAR(500) PRIMARY KEY,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(500),
    customer_state VARCHAR(500)
);

CREATE TABLE Payments (
    order_id VARCHAR(500) PRIMARY KEY,
    payment_sequential INT,
    payment_type VARCHAR(500),
    payment_installments INT,
    payment_value INT
);

CREATE TABLE Products (
    product_id VARCHAR(500),
    product_category_name VARCHAR(500),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- I made a mistake in the type columns for my tables, labelling price columns as integer values, so I have been getting errors. 
ALTER TABLE OrderItems
ALTER COLUMN price TYPE NUMERIC(10,2),
ALTER COLUMN shipping_charges TYPE NUMERIC (10,2);

ALTER TABLE Payments
ALTER COLUMN payment_value TYPE NUMERIC (10,2);

ALTER TABLE Products
ALTER COLUMN product_weight_g TYPE NUMERIC (10,2),
ALTER COLUMN product_length_cm TYPE NUMERIC (10,2),
ALTER COLUMN product_height_cm TYPE NUMERIC (10,2),
ALTER COLUMN product_width_cm TYPE NUMERIC (10,2);

ALTER TABLE Products2
ALTER COLUMN product_weight_g TYPE NUMERIC (10,2),
ALTER COLUMN product_length_cm TYPE NUMERIC (10,2),
ALTER COLUMN product_height_cm TYPE NUMERIC (10,2),
ALTER COLUMN product_width_cm TYPE NUMERIC (10,2);


-- I am now removing various primary key constraints
ALTER TABLE OrderItems
DROP CONSTRAINT orderitems_pkey;

ALTER TABLE Payments
DROP CONSTRAINT payments_pkey;

--orders and customers both worked
COPY Orders
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_Orders.csv'
DELIMITER ',' CSV HEADER;

COPY OrderItems
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_OrderItems.csv'
DELIMITER ',' CSV HEADER;

COPY Customers
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_Customers.csv'
DELIMITER ',' CSV HEADER;

COPY Payments
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_Payments.csv'
DELIMITER ',' CSV HEADER;

COPY Products
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_Products.csv'
DELIMITER ',' CSV HEADER;

COPY Products2
FROM 'C:\DA Projects\Ecommerce Order Dataset\train\df_Products.csv'
DELIMITER ',' CSV HEADER;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

