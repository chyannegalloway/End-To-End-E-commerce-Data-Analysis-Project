# End-To-End-E-Commerce-Data-Analysis-Project

## Introduction

From a [Brazilian E-Commerce Order & Supply Chain dataset](https://www.kaggle.com/datasets/bytadit/ecommerce-order-dataset), I performed an End-to-End data analysis project involving SQL and PowerBI. I used SQL to clean the data, JOIN the tables to view them in PowerBI, and perform various aggregations to analyse the data, as I would find it simpler to use SQL queries for more complicated aggregations (like rolling monthly revenue calculations) than DAX. I, then, used PowerBI to create a dashboard showcasing various aspects of my analysis, whilst using simple DAX queries to return various simple KPIs to include in the dashboard. This project improved by confidence and capabilities in SQL, writing complex SQL queries as well as being intentional with the views I connect to PowerBi. 

## Data Cleaning

This dataset including multiple tables, so I began the project by cleaning each table individually in PostgreSQL. In each table, I checked for duplicate values, NULL values, impossible values like negative prices or invalid dates. For two of the five tables, I had to perform more in depth analysis. 

There were NULL values returned in the 'Orders' table, the majority being in the 'order_delivered_timestamp' column. Through further investigation, by checking the order status of the NULL values,  the NULL values were mostly shipped. This result makes sense, as it could mean that these orders were never delivered due to being cancelled, or lost in postage. There were 6 NULL values that were returned as delivered. I determined that, since there was no consistent pattern as to why these order deliveries were returned NULL, therefore there must have been insufficient information to accurately determine the actual delivery date for these orders. 

The 'Products' table contained duplicate values. For 89316 total rows there are only 27451 unique product ids. This could have been completely reasonable, but I did some further investigation to determine if it was a problem in the dataset. I checked in the occurrences in the product ids in the 'Products' table matched with the 'OrderItems' table, which returned true. I created a 'products_clean' table, which made the product_id the primary key, which gives a unique identifier to each record associated with a primary key value. 

Also in the 'Products' table, I noticed that there were a large number of unique values in the 'product_category_name' column. In order to group these values together, I created another table which I named 'product_categories' that mapped the product names into more general titles, such as 'Fashion', 'Home' etc. I would then join this to the cleaned 'Products' table for the analysis. 

## Data Analysis in SQL

## Dashboard Creation in PowerBI
