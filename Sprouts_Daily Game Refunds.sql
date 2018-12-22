SELECT 
SUM(CAST(ROUND(a.charged_amount/f.exchange_rate, 2) as NUMERIC(19,2))) AS Nxm_sanitized_reversals,
order_charged_date,
CASE 
        WHEN product_id = 'com.grandcru.battlejack' THEN 'Battlejack'
        WHEN product_id = 'com.nexonm.dominations.adk' THEN 'Dominations'
        WHEN product_id = 'com.nexonm.tfa' THEN 'Titanfall'
        WHEN product_id = 'com.nexonm.sprouts' THEN 'Sprouts'
        ELSE 'Ignore'
END AS game        
from dg_stage.google_sales_reports a
LEFT JOIN dg_stage.forex f on a.order_charged_timestamp BETWEEN f.start_date AND nvl (f.end_date, sysdate+2) AND a.currency_of_sale = f.currency
WHERE charged_amount < 0.00 AND product_id in('com.grandcru.battlejack', 'com.nexonm.dominations.adk', 'com.nexonm.tfa', 'com.nexonm.sprouts')
GROUP BY product_id, order_charged_date
ORDER BY order_charged_date DESC, game
