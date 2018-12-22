SELECT 
segment, variant, usersystem, country, COUNT(a.user_id) as players,
SUM(D1R) as D1_Retained, SUM(D3R) as D3_Retained, SUM(D7R) as D7_Retained, SUM(D14R) as D14_Retained, SUM(D30R) as D30_Retained, SUM(D90R) as D90_Retained, SUM(D120R) as D120_Retained, -- retention
SUM(D1S) as D1_Rev, SUM(D3S) as D3_Rev, SUM(D7S) as D7_Rev, SUM(D14S) as D14_Rev, SUM(D30S) as D30_Rev, SUM(D90S) as D90_Rev, SUM(D120S) as D120_Rev, -- revenue
SUM(d1iap) as d1iap, SUM(d3iap) as d3iap, SUM(d7iap) as d7iap, SUM(d14iap) as d14iap, SUM(d30iap) as d30iap, SUM(d120iap) as d120iap, -- iap
SUM(d1_ad) as d1ad, SUM(d3_ad) as d3ad, SUM(d7_ad) as d7ad, SUM(d14_ad) as d14ad, SUM(d30_ad) as d30ad, SUM(d120_ad) as d120ad -- ad revenue
FROM (
      SELECT user_id  -- Pulling out all experiment IDs
      FROM public.tbl_choices_lp_sessions 
      WHERE (position('4818362268647424' in experiments)>0 OR position('4844275773472768' in experiments)>0)
      AND country IN ('AU', 'NZ')
      AND NOT(position('4834630951239680' in experiments)>0)
      GROUP BY user_id
     ) x
     LEFT JOIN
     (
      SELECT user_id, country, CASE WHEN usersystem = 'iOS' OR usersystem = 'iPhone OS' THEN 'iOS' ELSE usersystem END,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '1 day') THEN 1 ELSE NULL END) as D1R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '3 day') THEN 1 ELSE NULL END) as D3R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '7 day') THEN 1 ELSE NULL END) as D7R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '14 day') THEN 1 ELSE NULL END) as D14R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '30 day') THEN 1 ELSE NULL END) as D30R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '90 day') THEN 1 ELSE NULL END) as D90R,
      MIN( CASE WHEN DATE_TRUNC('day', sessiontime::timestamp)= DATE_TRUNC('day', user_install_time::timestamp + interval '120 day') THEN 1 ELSE NULL END) as D120R,
      CASE 
       WHEN position('4818362268647424' in experiments)>0 THEN 'Extants'
       WHEN position('4844275773472768' in experiments)>0 THEN 'New'
       ELSE 'poppycock' END AS segment,
      CASE  
       WHEN (position('6007486832967680' in experiments)>0 OR position('5627025807900672' in experiments)>0) THEN 'Control' 
       WHEN (position('6590671920824320' in experiments)>0 OR position('4608942045659136' in experiments)>0) THEN 'Incent Only' 
       WHEN (position('5700056258707456' in experiments)>0 OR position('5755273566224384' in experiments)>0) THEN 'Hybrid' 
       ELSE 'poppycock' END AS variant
      FROM public.tbl_choices_lp_sessions 
      WHERE country IN ('AU', 'NZ') AND usersystem IS NOT NULL
      GROUP BY 1, 2, 3, segment, variant
    ) a ON x.user_id = a.user_id
LEFT JOIN 
  (
  SELECT bb.user_id, max(d1) as D1S, max(d3) as D3S, max(d7) as D7S, max(d14) as D14S, max(d30) as D30S, max(d90) as D90S, max(d120) as D120S, --total value
  max(D1_iap) as d1iap, max(D3_iap) as d3iap, max(D7_iap) as d7iap, max(D14_iap) as d14iap, max(D30_iap) as d30iap, max(D90_iap) as d90iap, max(D120_iap) as d120iap, -- iap_value
  max(D1_ad) as d1_ad, max(D3_ad) as d3_ad, max(D7_ad) as d7_ad, max(D14_ad) as d14_ad, max(D30_ad) as d30_ad, max(D90_ad) as d90_ad, max(D120_ad) as d120_ad -- ad value
  FROM (
      SELECT user_id -- Pulling out all experiment IDs as lookups
      FROM public.tbl_choices_lp_sessions 
      WHERE (position('4818362268647424' in experiments)>0 OR position('4844275773472768' in experiments)>0)
      AND country IN ('AU', 'NZ')
      GROUP BY user_id
       ) xx
  LEFT JOIN     
       (
       SELECT user_id, DATEDIFF(day, user_install_time, sessiontime) as dsi, max(total_value) as spend, -- Pulling out all experiment IDs as lookups
       max(cumulative_iap_value) AS iap_value, max(cumulative_iap_value) AS iap_value,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 1 THEN max(total_value) ELSE 0.0 END as D1, -- total ad_value
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 3 THEN max(total_value) ELSE 0.0 END as D3,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 7 THEN max(total_value) ELSE 0.0 END as D7,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 14 THEN max(total_value) ELSE 0.0 END as D14,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 30 THEN max(total_value) ELSE 0.0 END as D30,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 90 THEN max(total_value) ELSE 0.0 END as D90,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 120 THEN max(total_value) ELSE 0.0 END as D120,
              CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 1 THEN max(cumulative_iap_value) ELSE 0.0 END as D1_iap, -- iap_value
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 3 THEN max(cumulative_iap_value) ELSE 0.0 END as D3_iap,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 7 THEN max(cumulative_iap_value) ELSE 0.0 END as D7_iap,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 14 THEN max(cumulative_iap_value) ELSE 0.0 END as D14_iap,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 30 THEN max(cumulative_iap_value) ELSE 0.0 END as D30_iap,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 90 THEN max(cumulative_iap_value) ELSE 0.0 END as D90_iap,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 120 THEN max(cumulative_iap_value) ELSE 0.0 END as D120_iap,
              CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 1 THEN max(advalue) ELSE 0.0 END as D1_ad, -- ad value
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 3 THEN max(advalue) ELSE 0.0 END as D3_ad,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 7 THEN max(advalue) ELSE 0.0 END as D7_ad,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 14 THEN max(advalue) ELSE 0.0 END as D14_ad,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 30 THEN max(advalue) ELSE 0.0 END as D30_ad,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 90 THEN max(advalue) ELSE 0.0 END as D90_ad,
       CASE WHEN DATEDIFF(day, user_install_time, sessiontime) <= 120 THEN max(advalue) ELSE 0.0 END as D120_ad
       FROM public.tbl_choices_lp_sessions 
       WHERE country IN ('AU', 'NZ') AND usersystem IS NOT NULL
       GROUP BY 1,2 
        ) bb ON xx.user_id = bb.user_id
   GROUP BY 1
   ) b
   ON b.user_id = a.user_id
GROUP BY 1, 2, 3, 4 ORDER BY 1, 2, 3, 4





SUM(d1_ad) as d1iap, SUM(d3_ad) as d3iap, SUM(d7_ad) as d7iap, SUM(d14_ad) as d14iap, SUM(d30_ad) as d30iap, SUM(d120_ad) as d120iap -- ad revenue