USE OlistDB;

-- Q7: How does late delivery affect customer review scores?
WITH order_scores AS (
    SELECT
        order_id,
        AVG(review_score*1.0) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    v.is_late,
    COUNT(*) AS delivered_orders,
    CAST(AVG(os.review_score) AS DECIMAL(3,2)) AS avg_review_score,
    CAST(SUM(CASE WHEN os.review_score <= 2 THEN 1 ELSE 0 END) *100.0 / COUNT(*) AS DECIMAL(5,2)) AS low_score_pct
FROM dbo.vw_delivered_orders v
JOIN order_scores os ON v.order_id = os.order_id
WHERE v.purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY v.is_late
ORDER BY v.is_late;