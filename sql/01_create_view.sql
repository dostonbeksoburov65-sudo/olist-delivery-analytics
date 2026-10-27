USE OlistDB;
GO

-- Clean view of delivered orders: excludes ~0.2% of rows with missing or illogical dates

CREATE OR ALTER VIEW dbo.vw_delivered_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_state,
    o.order_purchase_timestamp,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    DATEFROMPARTS(YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), 1) AS purchase_month,
    DATEDIFF(HOUR, o.order_purchase_timestamp, o.order_delivered_customer_date) / 24.0 AS delivery_days,
    CASE WHEN CAST(o.order_delivered_customer_date AS DATE) > CAST(o.order_estimated_delivery_date AS DATE)
         THEN 1 ELSE 0 END AS is_late
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_delivered_carrier_date IS NOT NULL
  AND o.order_delivered_carrier_date >= o.order_purchase_timestamp
  AND o.order_delivered_customer_date >= o.order_delivered_carrier_date;
GO

SELECT COUNT(*) AS clean_orders FROM dbo.vw_delivered_orders;