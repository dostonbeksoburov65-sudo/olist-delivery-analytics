USE OlistDB;

-- Q2: How did average and median delivery time change by month?

WITH delivery_month_median AS (
	SELECT
		purchase_month,
		delivery_days,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY delivery_days)
			OVER(PARTITION BY purchase_month) AS median_days
	FROM dbo.vw_delivered_orders
) 
SELECT
purchase_month AS order_month,
COUNT(*) AS delivered_orders,
CAST(AVG(delivery_days) AS DECIMAL(10,1)) AS avg_delivery_days,
CAST(MAX(median_days) AS DECIMAL(10,1)) AS median_delivery_days
FROM delivery_month_median
WHERE purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY purchase_month
ORDER BY purchase_month;