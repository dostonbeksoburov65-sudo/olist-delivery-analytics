USE OlistDB;

-- Data quality checks run before the analysis

-- 1. Order status distribution
SELECT
    order_status,
    COUNT(*) AS count_orders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM orders
GROUP BY order_status
ORDER BY count_orders DESC;

-- 2. Missing and illogical dates among delivered orders
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS missing_delivery_date,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS missing_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date < order_purchase_timestamp THEN 1 ELSE 0 END) AS delivered_before_purchase,
    SUM(CASE WHEN order_delivered_carrier_date < order_purchase_timestamp THEN 1 ELSE 0 END) AS carrier_before_purchase,
    SUM(CASE WHEN order_delivered_customer_date < order_delivered_carrier_date THEN 1 ELSE 0 END) AS customer_before_carrier
FROM orders
WHERE order_status = 'delivered';

-- 3. Duplicate order_id check
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- 4. Orders with more than one review (fan-out risk for joins)
SELECT COUNT(*) AS total_reviews, COUNT(DISTINCT order_id) AS unique_orders
FROM order_reviews;
