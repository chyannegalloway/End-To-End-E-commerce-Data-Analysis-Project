# End-To-End-E-Commerce-Data-Analysis-Project

## Introduction

From a [Brazilian E-Commerce Order & Supply Chain dataset](https://www.kaggle.com/datasets/bytadit/ecommerce-order-dataset), I performed an End-to-End data analysis project involving SQL and PowerBI. I used SQL to clean the data, JOIN the tables to view them in PowerBI, and perform various aggregations to analyse the data, as I would find it simpler to use SQL queries for more complicated aggregations (like rolling monthly revenue calculations) than DAX. I, then, used PowerBI to create a dashboard showcasing various aspects of my analysis, whilst using simple DAX queries to return various simple KPIs to include in the dashboard. This project improved by confidence and capabilities in SQL, writing complex SQL queries as well as being intentional with the views I connect to PowerBi. 

## The Dataset

This dataset provides information for an e-commerce platform. This dataset is structured with multiple tables; 'Orders', 'OrderItems', 'Customers', 'Payments' and 'Products', each containing specific information about various aspects of the e-commerce operations. 

A negative of this dataset is that I am unsure of the currency that the price columns are set in. The dataset gathers information from a Brazilian company, however it is unclear whether the currency is set to Brazilian Real, or US dollars. For the sake of this write-up, I will be assuming that the revenue is in US dollars as it is the standard trade currency. All in all, the actual values of the prices and revenue are of little importance, rather it is the way the revenue changes over time, or per category that is of importance here. 

## Data Cleaning

This dataset including multiple tables, so I began the project by cleaning each table individually in PostgreSQL. In each table, I checked for duplicate values, NULL values, impossible values like negative prices or invalid dates. For two of the five tables, I had to perform more in depth analysis. 

There were NULL values returned in the 'Orders' table, the majority being in the 'order_delivered_timestamp' column. Through further investigation, by checking the order status of the NULL values,  the NULL values were mostly shipped. This result makes sense, as it could mean that these orders were never delivered due to being cancelled, or lost in postage. There were 6 NULL values that were returned as delivered. I determined that, since there was no consistent pattern as to why these order deliveries were returned NULL, therefore there must have been insufficient information to accurately determine the actual delivery date for these orders. 

The 'Products' table contained duplicate values. For 89316 total rows there are only 27451 unique product ids. This could have been completely reasonable, but I did some further investigation to determine if it was a problem in the dataset. I checked in the occurrences in the product ids in the 'Products' table matched with the 'OrderItems' table, which returned true. I created a 'products_clean' table, which made the product_id the primary key, which gives a unique identifier to each record associated with a primary key value. 

Also in the 'Products' table, I noticed that there were a large number of unique values in the 'product_category_name' column. In order to group these values together, I created another table which I named 'product_categories' that mapped the product names into more general titles, such as 'Fashion', 'Home' etc. I would then join this to the cleaned 'Products' table for the analysis. 

```
SELECT
    products_clean.product_id,
    products_clean.product_category_name,
    product_categories.broader_category
FROM products_clean
LEFT JOIN product_categories ON products_clean.product_category_name = product_categories.product_category_name
ORDER BY products_clean.product_id;
```

## Data Analysis in SQL

Before beginning the actual analysis, I first created analytical datasets by joining the tables together, depending on the specific questions or category of questions I wanted to answer. For example, for analysis concerning the sales performance specifically, I created an analytical dataset which joined the 'Orders' and 'OrderItems' tables through the 'order_id. 
```
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_timestamp,
    oi.price,
    oi.shipping_charges
FROM Orders o
LEFT JOIN orderitems oi ON o.order_id = oi.order_id
ORDER BY o.order_id;
```
The primary role of the SQL analysis was to create these views to use in PowerBI, and to perform more complex analysis here that I could view in PowerBI, as opposed to performing complex DAX functions. This is because I am more confident in SQL aggregations, and could perform these quickly. I still performed simple aggregations in SQL, so that when I gathered the same insights in PowerBI through DAX, I could check that I performed it correctly. 

### Sales Performance Analysis

Here, I answered basic business questions; 'How much revenue did the business generate?' and 'How does revenue change over time?'. I also determined the rolling 3-month revenue, with a more complex CTE.

```
WITH salesperformance AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_timestamp,
        oi.price,
        oi.shipping_charges
    FROM Orders o
    LEFT JOIN orderitems oi ON o.order_id = oi.order_id
    ORDER BY o.order_id
),

quarterly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_delivered_timestamp) AS Year,
        EXTRACT(QUARTER FROM order_delivered_timestamp) AS Quarter,
        COUNT(*) AS Purchases,
        SUM(price) AS total_sales
    FROM salesperformance
    GROUP BY 
        EXTRACT(YEAR FROM order_delivered_timestamp),
        EXTRACT(QUARTER FROM order_delivered_timestamp)
    )

SELECT
    Year,
    Quarter,
    Purchases,
    total_sales,
    SUM(total_sales) OVER (ORDER BY Year, Quarter) AS cumulative_total
FROM quarterly_sales
WHERE Year IS NOT NULL AND Quarter IS NOT NULL
ORDER BY Year, Quarter;
```
This analysis was done in order to create a graph in PowerBI later on in this project. 

### Order Analysis

For this section, I performed simple aggregations in order to get some key insights. 
- From a total of 89316 orders, 87428 were delivered, which is 97.8% of all orders.
- The majority of orders were delivered within a week, or 7 days.
- 7.71% of orders were delivered later than estimated.

### Product Analysis

This section required a number of joins, as the original table didn't include the price of the purchased product, nor the date it was purchased. The majority of the analysis done here was through using JOINS and CTEs to gather the necessary information. A complex CTE I performed was in determining which product categories grow or decline over time. 

```
WITH product_orders AS (
    SELECT 
        o.order_id,
        o.order_purchase_timestamp,
        oi.product_id
    FROM orders o
    INNER JOIN orderitems oi ON o.order_id = oi.order_id
),

product_join_2 AS (
    SELECT 
        order_id,
        order_purchase_timestamp,
        po.product_id,
        p.product_category_name
    FROM product_orders po
    INNER JOIN products_clean p ON po.product_id = p.product_id
),

product_category_join AS (
    SELECT 
        order_purchase_timestamp,
        pj.product_id, 
        pc.broader_category
    FROM product_join_2 pj
    INNER JOIN product_categories pc ON pj.product_category_name = pc.product_category_name
)

SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS Year,
 -- EXTRACT (MONTH FROM order_purchase_timestamp) AS Month,
    broader_category,
    COUNT(broader_category) AS purchases
FROM product_category_join
GROUP BY
    EXTRACT(YEAR FROM order_purchase_timestamp),
 -- EXTRACT (MONTH FROM order_purchase_timestamp),
    broader_category
ORDER BY Year
```

## Dashboard Creation in PowerBI

In order to connect my SQL server to PowerBI, I used SQL views

### Overall Breakdown

For the first page of my dashboard, I sought to include the most important KPIs and graphs, in order to give a general overview of the major insights gathered from this project. I used DAX measures to create cards for the 'Total Revenue', 'Total Orders', and 'Average Order Value'. The total revenue generated by the company is $30.4 million over a 2-year period. 

```
Total Revenue = SUM('public salesperformance_analysis'[price])
Total Orders = DISTINCTCOUNT('public salesperformance_analysis'[order_id])
Average Order Value = DIVIDE([Total Revenue], [Total Orders])
```

I included:
- A line and clustered column chart which showed how the total revenue and total number of orders changed over monthly intervals. From October 2016 to November 2017, the revenue increased overall. For the remainder of the period, the revenue remained consistent. The total number of orders showed a similar pattern. For the most part, when the total number of orders increased, the revenue also increased.
- A clustered horizontal bar chart showcasing which cities generated the most revenue. As expected, the most populated cities generated the most revenue.
- Two donut charts which showed breakdowns of the most purchased category and the most used payment type. The most purchased category was 'Hobbies', contributing to 78.3% of total orders. The most used payment type was credit card, making up 73.9% of total orders.
- A slicer of the timeline of orders purchased. This was added to show how the various plots change depending of the time period. 

<img width="1435" height="802" alt="E-Commerce Dataset Overall Breakdown Page" src="https://github.com/user-attachments/assets/3972c3f9-0086-422d-ab82-3343695e6de6" />

### Sales Performance

Here, I sought to display a more in depth analysis of the total revenue generated by the company, and how different factors affect it. The most intuitive was to create a plot of the total revenue by category. It is clear that the 'Hobbies' category generates the most revenue by a significant amount. From further insights in SQL, I gathered that within this hobbies category, the most purchased item were 'Toys'. The dataset does not give any further details into what specific toys were bought. This differs from the pie chart I included in my first page because it gives an approximate value for the revenue generated, as opposed to a percentage or a proportion. The other simple plot I included here was the pie chart showing total revenue by year. The revenue generated between the years 2017 and 2018 were similar, with only a $2 million difference. 

The first line graph I included showed the percentage growth over time. I limited the time to not include any month in 2016. This is because the percentage difference here was incredibly large, which skewed the plot greatly to a point where the remaining values weren't able to be shown in great detail. The reason for this huge discrepancy was the large difference in the number of sales between September and October 2016 as well as December 2016 and January 2017. For the sake of visibility, I chose to exclude these values from the line graph. Overall, the percentage growth didn't deviate too greatly, outside of the large 99.13% increase in November 2017. 

I included a line and clustered column chart to showcase the monthly revenue (columns) compared with the target monthly revenue (line). I performed an aggregation in SQL to achieve the monthly revenue target. 
```
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price + oi.shipping_charges) AS monthly_revenue
    FROM orders o
    JOIN orderitems oi
        ON o.order_id = oi.order_id
    GROUP BY
        DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY month
    ) * 1.05 AS revenue_target

FROM monthly_revenue
ORDER BY month;
```
This projected the target revenue as a 5% increase to the monthly revenue. Overall, the monthly revenue closely resembled the target, except at the large increase at November 2017. Here, since the total orders were so greatly increased, the target predicted the December sales to follow closely. However, since November is seemingly an outlier, the December sales resembled closer to that of the other months, and the target greatly differed from this. 

The final plot I included here was a line chart depicting the rolling 3-month revenue compared to the monthly revenue. I included this graph as it reduced short-term fluctuations, making the overall trend easier to see. The rolling revenue is shown to be steadily increasing, meaning that the business has sustained growth. November 2017 was an unusual month in terms of revenue, but the remainder of the months again showed sustained growth. 

A downside to this page is that I didn't include a slicer. This is because that the years used between the three time-series graphs were pulled from different tables that weren't connected by relationships in the model view. 

<img width="1432" height="802" alt="Sales Performance Page" src="https://github.com/user-attachments/assets/6d730112-6d2d-42b2-9415-cf9ae2c421fd" />

### Order Analysis

Through this page I sought out to examine the trends in the orders, number of orders, deliveries and the factors which effect them. Like the overall breakdown page, I started with some basic KPIs, again using simple DAX calculations:
- There were 87000 orders delivered.
- The average delivery time was 12 days.
```
Number of Delivered Orders = CALCULATE(DISTINCTCOUNT('public orders'[order_id]), 'public orders'[order_status] = "delivered")
Average Delivery Time = AVERAGEX('public orders', DATEDIFF('public orders'[order_purchase_timestamp], 'public orders'[order_delivered_timestamp], DAY))
```
I also included a pie chart showing the proportion of deliveries that were on=time compared to late deliveries. 7.54% of deliveries were delivered after the estimated date. 

The first of the main charts I included here was to show the number of orders by month. This was included to determine if there was a specific month that showed the most sales, and if customers were more inclined to buy from the company in one specific month. I had previously assumed that December would be a month that had a higher amount of orders compared to previous months, due to Christmas sales. However, as was shown on the chart, the number of orders didn't differ greatly between months. August had the highest number of orders, at 9583 sales, with May coming in second with 9570 sales. September had the lowest number of sales at 3941 sales. 

I included a graph that showed, of the deliveries that were late, by how many days were they delayed. Here, the majority of late orders were delivered 7 days late. The distribution shown was skewed towards the lower end of delay time.

The final graph included here was to show the number of orders by day of the month. This was used to determine if there was a trend in the time of the month when orders were placed. The highest number of the orders were placed on the 24th day of the month, with 3480 orders placed. Overall, the number of orders placed remained consistent across the days. 

Finally, I included a button slicer for the category type, to show if there were any significant differences based on the specific category bought. 

<img width="1431" height="803" alt="Order Analysis Page" src="https://github.com/user-attachments/assets/d9934e8f-187e-4545-931a-0ac02d9eeaa5" />

