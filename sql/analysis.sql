-- =====================================================
-- Messy E-commerce SQL Analysis
--
-- This file contains analytical SQL queries focused on:
-- - data validation
-- - revenue calculation
-- - customer-level reporting
-- - country-level reporting
-- - data quality summary
--
-- Techniques used:
-- - LEFT JOIN
-- - CASE
-- - COALESCE
-- - GROUP BY
-- - CTE
-- - Window functions
-- - RANK
-- =====================================================

-- 1. Customers without orders
SELECT
    c.customer_id AS customer_id,
    c.customer_name AS customer_name,
    c.country AS country
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 2. Total valid revenue
SELECT
    SUM(
        CASE 
            WHEN o.status = 'completed'
            AND oi.unit_price IS NOT NULL
            THEN oi.unit_price * oi.quantity 
            ELSE 0 
        END
    ) AS total_revenue
FROM order_items oi 
JOIN orders o ON o.order_id = oi.order_id;

-- 3. Invalid order items
SELECT
    oi.order_item_id AS order_item_id,
    oi.order_id AS order_id,
    oi.product_id AS product_id,
    CASE 
        WHEN oi.unit_price IS NULL THEN 'missing_price' 
        WHEN o.order_id IS NULL THEN 'missing_order' 
    END AS reason
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_id IS NULL
    OR oi.unit_price IS NULL;

-- 4. Revenue per customer including zero-revenue customers
SELECT
    c.customer_name AS customer_name,
    c.country AS country,
    COALESCE(
        SUM(
            CASE 
                WHEN o.status = 'completed'
                AND oi.unit_price IS NOT NULL
                THEN oi.unit_price * oi.quantity 
                ELSE 0 
            END
        ),
        0
    ) AS total_revenue
FROM customers c 
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_name, c.country;

-- 5. Completed order count per customer
SELECT
    c.customer_name AS customer_name,
    COUNT(CASE WHEN o.status = 'completed' THEN o.order_id END) AS completed_order_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_name;

-- 6. Top customers by revenue
WITH customer_revenue AS (
    SELECT
        c.customer_name AS customer_name,
        c.country AS country,
        COALESCE(
            SUM(
                CASE 
                    WHEN o.status = 'completed' 
                    AND oi.unit_price IS NOT NULL
                    THEN oi.unit_price * oi.quantity 
                    ELSE 0 
                END
            ), 
            0
        ) AS total_revenue
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_name, c.country)
SELECT
    customer_name,
    country,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rnk
FROM customer_revenue;

-- 7. Revenue by country and share of total
WITH country_revenue AS (
    SELECT
        c.country AS country,
        SUM(
            CASE 
                WHEN o.status = 'completed' 
                AND oi.unit_price IS NOT NULL
                THEN oi.unit_price * oi.quantity 
                ELSE 0 
            END
        ) AS total_revenue
    FROM order_items oi 
    JOIN orders o ON o.order_id = oi.order_id
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY c.country)
SELECT
    country,
    total_revenue,
    ROUND(total_revenue * 100.00 / SUM(total_revenue) OVER (), 2) AS share_of_total
FROM country_revenue;

-- 7. Revenue by country and share of total
SELECT
    CASE
        WHEN o.order_id IS NULL THEN 'missing_order_revenue'
        WHEN oi.unit_price IS NULL THEN 'missing_price_revenue'
        WHEN o.status = 'refunded' THEN 'refunded_revenue'
        WHEN o.status = 'completed' THEN 'valid_revenue'
    END AS revenue_type,
    SUM(COALESCE(oi.unit_price * oi.quantity, 0)) AS amount
FROM order_items oi
LEFT JOIN orders o
    ON o.order_id = oi.order_id
GROUP BY
    CASE
        WHEN o.order_id IS NULL THEN 'missing_order_revenue'
        WHEN oi.unit_price IS NULL THEN 'missing_price_revenue'
        WHEN o.status = 'refunded' THEN 'refunded_revenue'
        WHEN o.status = 'completed' THEN 'valid_revenue'
    END;