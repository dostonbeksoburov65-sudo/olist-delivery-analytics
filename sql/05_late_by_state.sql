USE OlistDB;

-- Q4: Which customer states have the highest late delivery rate? (states with 500+ orders)

SELECT
customer_state,
COUNT(*) AS delivered_orders,
SUM(is_late) AS late_orders,
CAST(SUM(is_late) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS late_percentage
FROM dbo.vw_delivered_orders
WHERE purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY customer_state
HAVING COUNT(*) >= 500
ORDER BY late_percentage DESC;

