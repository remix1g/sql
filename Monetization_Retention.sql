Player_Level_Dive

layer_level
\o 2013_12_06_WoN_iOS_Retention_Monetization.csv

SELECT device_type, total_users, users_7d, users_14d, users_21d, users_30d, retention_7d, retention_14d, retention_21d, retention_30d,
spenders_week1,spenders_week2,spenders_week3, spenders_week4, pct_spender_week1, pct_spender_week2, pct_spender_week3, pct_spender_week4,
rev_week_1, rev_week_2, rev_week_3, rev_week_4, ARPU_week_1, ARPU_week_2, ARPU_week_3, ARPU_week_4, ARPPU_week_1, ARPPU_week_2, ARPPU_week_3, ARPPU_week_4
FROM
(

SELECT device_type, count(1) as total_users, SUM(retain_day_7) as users_7d, SUM(retain_day_14) as users_14d, SUM(retain_day_21) as users_21d, SUM(retain_day_30) as users_30d, 
AVG(retain_day_7) as retention_7d, AVG(retain_day_14) as retention_14d, AVG(retain_day_21) as retention_21d, AVG(retain_day_30) as retention_30d,
SUM(flag_spend_week_1) as spenders_week1, SUM(flag_spend_week_2) as spenders_week2, SUM(flag_spend_week_3) as spenders_week3, SUM(flag_spend_week_4) as spenders_week4, 
AVG(flag_spend_week_1) as pct_spender_week1, AVG(flag_spend_week_2) as pct_spender_week2, AVG(flag_spend_week_3) as pct_spender_week3, AVG(flag_spend_week_4) as pct_spender_week4, 
SUM(usd_week_1) as rev_week_1, SUM(usd_week_2) as rev_week_2, SUM(usd_week_3) as rev_week_3, SUM(usd_week_4) as rev_week_4, 
SUM(usd_week_1)/count(1) as ARPU_week_1, SUM(usd_week_2)/count(1) as ARPU_week_2, SUM(usd_week_3)/count(1) as ARPU_week_3, SUM(usd_week_4)/count(1) as ARPU_week_4, 
SUM(usd_week_1)/SUM(flag_spend_week_1) as ARPPU_week_1, SUM(usd_week_2)/SUM(flag_spend_week_2) as ARPPU_week_2, SUM(usd_week_3)/SUM(flag_spend_week_3) as ARPPU_week_3, SUM(usd_week_4)/SUM(flag_spend_week_4) as ARPPU_week_4
FROM
(

SELECT base.player_id, base.device_type, base.retain_day_7, base.retain_day_14, ba
se.retain_day_21, base.retain_day_30,
COALESCE(monetization_1.usd_week_1,0) as usd_week_1, COALESCE(monetization_1.flag_spend_week_1,0) as flag_spend_week_1,
COALESCE(monetization_2.usd_week_2,0) as usd_week_2, COALESCE(monetization_2.flag_spend_week_2,0) as flag_spend_week_2,
COALESCE(monetization_3.usd_week_3,0) as usd_week_3, COALESCE(monetization_3.flag_spend_week_3,0) as flag_spend_week_3,
COALESCE(monetization_4.usd_week_4,0) as usd_week_4, COALESCE(monetization_4.flag_spend_week_4,0) as flag_spend_week_4
FROM
(
SELECT player_id, device_type,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=1 THEN 1 ELSE 0 END) as retain_day_1,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=2 THEN 1 ELSE 0 END) as retain_day_2,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=3 THEN 1 ELSE 0 END) as retain_day_3,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=4 THEN 1 ELSE 0 END) as retain_day_4,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=5 THEN 1 ELSE 0 END) as retain_day_5,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=7 THEN 1 ELSE 0 END) as retain_day_7,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=14 THEN 1 ELSE 0 END) as retain_day_14,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=21 THEN 1 ELSE 0 END) as retain_day_21,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=30 THEN 1 ELSE 0 END) as retain_day_30
FROM
( --OK
SELECT player_id, device_type, DATE(player_time_created) as player_create_day, DATE(time_created) as day
FROM gc_dw_ios.player_login
WHERE DATE(player_time_created) + INTERVAL '30 DAY' >= DATE(time_created) --come back within 30 day after creating account
AND (player_filter = 0 or player_filter IS NULL) --no test accounts
AND player_time_created>='2013-09-01 00:00:00'
AND player_time_created<'2013-11-01 00:00:00'
GROUP BY player_id, device_type, player_create_day, day
) as player_retain_log
GROUP BY player_id, device_type
ORDER BY player_id, device_type
) as base

LEFT JOIN
(
SELECT player_id, sum(usd_cost) as usd_week_1, 1 as flag_spend_week_1
FROM gc_dw_ios.in_app_payment_redemption
WHERE time_created <=  --player_time_created + INTERVAL '7 DAY' --spend in 1st week of Account creation
AND (player_filter = 0 or player_filter IS NULL)
GROUP BY player_id
) as monetization_1
ON base.player_id = monetization_1.player_id

LEFT JOIN
(
SELECT player_id, sum(usd_cost) as usd_week_2, 1 as flag_spend_week_2
FROM gc_dw_ios.in_app_payment_redemption
WHERE player_time_created + INTERVAL '7 DAY' < time_created 
AND time_created <=  player_time_created + INTERVAL '14 DAY' --spend in 2nd week of Account creation 
AND (player_filter = 0 or player_filter IS NULL)
GROUP BY player_id
) as monetization_2
ON base.player_id = monetization_2.player_id

LEFT JOIN