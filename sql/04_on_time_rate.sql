USE OlistDB;

-- Q3: What share of orders were delivered on time each month?

SELECT
purchase_month AS order_month,
COUNT(*) AS delivered_orders,
SUM(is_late) AS late_orders,
CAST((COUNT(*) - SUM(is_late)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS on_time_rate_pct
FROM dbo.vw_delivered_orders
WHERE purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY purchase_month
ORDER BY purchase_month;

