# Messy E-commerce SQL Analysis

This project analyzes a small e-commerce dataset with intentionally messy data.

The goal is to practice analytical SQL on more realistic scenarios involving data quality issues and business rules.

## Dataset

The dataset contains four tables:

- customers
- products
- orders
- order_items

It also includes common real-world data problems such as:

- customers without orders
- refunded orders
- missing prices
- orphan order items
- duplicate-like rows

Revenue is calculated using:

`quantity * unit_price`

Only **valid revenue rows** are included in revenue metrics:

- order must exist
- order status must be `completed`
- `unit_price` must not be `NULL`

## Analysis Questions

This project answers the following business and data-quality questions:

1. Which customers have no orders?
2. What is the total valid revenue?
3. Which order item rows are invalid and why?
4. What is the revenue per customer, including customers with zero revenue?
5. How many completed orders does each customer have?
6. Who are the top customers by revenue?
7. What is the revenue by country and each country's share of total revenue?
8. How much revenue is valid, refunded, missing due to missing prices, or tied to missing orders?

## SQL Concepts Used

- LEFT JOIN
- CASE
- COALESCE
- GROUP BY
- CTE
- Window functions
- RANK
- Aggregate functions

## Project Structure

text
messy-ecommerce-sql-analysis
│
├─ data
│  └─ dataset.sql
│
├─ sql
│  └─ analysis.sql
│
└─ README.md

## Purpose

This project is part of my learning journey in SQL and data analytics.

The goal of this analysis is to practice working with messy and imperfect datasets that resemble real-world scenarios.

Through this project I focus on:

- identifying data quality issues
- applying business logic to filter valid revenue
- building analytical queries for reporting
- understanding data granularity and joins
- practicing SQL techniques used in data analytics

This project demonstrates practical use of SQL for data validation and analytical reporting.