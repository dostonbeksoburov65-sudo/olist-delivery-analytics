USE OlistDB;

-- Q8: Which sellers (30+ orders) have the highest late delivery rate?

WITH unique_seller_orders AS (
    SELECT DISTINCT
        order_id,
        seller_id
    FROM dbo.order_items
)
SELECT TOP 10
    u.seller_id,
    COUNT(*) AS delivered_orders,
    CAST(SUM(v.is_late) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS late_percentage,
    CAST(AVG(DATEDIFF(HOUR, v.order_purchase_timestamp, v.order_delivered_carrier_date) / 24.0) AS DECIMAL(5,2)) AS avg_seller_days
FROM dbo.vw_delivered_orders v
JOIN unique_seller_orders u ON v.order_id = u.order_id
WHERE v.purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY u.seller_id
HAVING COUNT(*) >= 30
ORDER BY late_percentage DESC;
