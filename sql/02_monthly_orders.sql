USE OlistDB;

-- Q1: How did the number of delivered orders change month over month?

WITH statistics_of_month AS (

SELECT
    purchase_month AS order_month,
    COUNT(*) AS delivered_orders
FROM dbo.vw_delivered_orders
GROUP BY purchase_month
)
SELECT 
order_month,
delivered_orders,
LAG(delivered_orders, 1) OVER (ORDER BY order_month) AS previous_month_orders,
CAST(
        (delivered_orders - LAG(delivered_orders, 1) OVER (ORDER BY order_month)) * 100.0 / 
        NULLIF(LAG(delivered_orders, 1) OVER (ORDER BY order_month), 0)  
     AS DECIMAL(10,2)
    ) AS percentage_change
FROM statistics_of_month
WHERE order_month BETWEEN '2017-01-01' AND '2018-08-01'
ORDER BY order_month


