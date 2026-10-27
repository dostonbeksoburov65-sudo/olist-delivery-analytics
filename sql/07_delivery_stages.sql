USE OlistDB;

-- Q6: In which stage do late orders lose the most time: seller handling or transit?

SELECT 
is_late,
COUNT(*) AS delivered_orders,
CAST(AVG(DATEDIFF(HOUR, order_purchase_timestamp, order_delivered_carrier_date) / 24.0) AS DECIMAL(5,2)) AS avg_seller_days,
CAST(AVG(DATEDIFF(HOUR, order_delivered_carrier_date, order_delivered_customer_date) / 24.0) AS DECIMAL(5,2)) AS avg_transit_days
FROM dbo.vw_delivered_orders
WHERE purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY is_late
ORDER BY is_late  