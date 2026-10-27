USE OlistDB;

-- Q5: What is the average freight cost per order by state, and what share of the order value does it make up?
WITH order_costs AS (
    SELECT
        order_id,
        SUM(price) AS items_value,
        SUM(freight_value) AS freight
    FROM order_items
    GROUP BY order_id
)
SELECT
    v.customer_state,
    COUNT(*) AS delivered_orders,
    CAST(AVG(oc.freight) AS DECIMAL(10,2)) AS avg_freight_per_order,
    CAST(SUM(oc.freight) * 100.0 / NULLIF(SUM(oc.items_value), 0) AS DECIMAL(5,2)) AS freight_share_pct
FROM dbo.vw_delivered_orders v
JOIN order_costs oc ON v.order_id = oc.order_id
WHERE v.purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY v.customer_state
HAVING COUNT(*) >= 500
ORDER BY avg_freight_per_order DESC;