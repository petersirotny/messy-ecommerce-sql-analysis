-- =====================================================
-- Messy E-commerce Dataset
--
-- Tables:
-- customers
-- products
-- orders
-- order_items
--
-- Purpose:
-- This dataset simulates real-world data issues such as:
-- - customers without orders
-- - refunded orders
-- - missing prices
-- - orphan order items
-- - duplicate-like rows
-- =====================================================

DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;

CREATE TABLE customers (
    customer_id INTEGER,
    customer_name TEXT,
    country TEXT
);

CREATE TABLE products (
    product_id INTEGER,
    product_name TEXT,
    category TEXT
);

CREATE TABLE orders (
    order_id INTEGER,
    customer_id INTEGER,
    order_date TEXT,
    status TEXT
);

CREATE TABLE order_items (
    order_item_id INTEGER,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price INTEGER
);

INSERT INTO customers VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'USA'),
(3, 'Carol', 'Canada'),
(4, 'Dave', 'Canada'),
(5, 'Eva', 'Germany'),
(6, 'Frank', 'Germany'),
(7, 'Gina', 'Austria');

INSERT INTO products VALUES
(1, 'Protein Powder', 'Supplements'),
(2, 'Creatine', 'Supplements'),
(3, 'Shaker Bottle', 'Accessories'),
(4, 'Resistance Bands', 'Equipment');

INSERT INTO orders VALUES
(101, 1, '2024-01-05', 'completed'),
(102, 1, '2024-01-10', 'completed'),
(103, 2, '2024-01-12', 'completed'),
(104, 3, '2024-01-15', 'refunded'),
(105, 4, '2024-01-20', 'completed'),
(106, 5, '2024-01-25', 'completed'),
(107, 6, '2024-01-28', 'completed'),
(108, 6, '2024-02-01', 'completed');

INSERT INTO order_items VALUES
(1, 101, 1, 1, 100),
(2, 101, 3, 2, 20),

(3, 102, 2, 1, 60),

(4, 103, 1, 1, 100),
(5, 103, 3, 1, 20),

(6, 104, 2, 2, 60),

(7, 105, 4, 1, 40),
(8, 105, 4, 1, 40),  -- duplicate-like revenue row

(9, 106, 1, 1, NULL), -- missing price

(10, 107, 2, 1, 60),

(11, 999, 1, 1, 100); -- orphan item, order does not exist
