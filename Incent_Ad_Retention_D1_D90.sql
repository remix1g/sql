
-- Incent Ad AB Test (New Users)
SELECT variant, 
       sum(total_players) as total_players,
       sum(retain_day_1) as d1,
       sum(retain_day_3) as d3,
       sum(retain_day_7) as d7,
       sum(retain_day_14) as d14,
       sum(retain_day_30) as d30,
       sum(retain_day_60) as d60,
       sum(retain_day_90) as d90
FROM
(
SELECT 
  user_id, count(distinct user_id) as total_players, CASE
                    WHEN position('6007486832967680' in experiments)>0 then 'control'
                    WHEN position('6590671920824320' in experiments)>0 then 'v1'
                    WHEN position('5700056258707456' in experiments)>0 then 'v2'
                    ELSE 'broken'
                END AS variant,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1 ELSE 0 END) as retain_day_90
FROM public.tbl_choices_lp_sessions_2017 --- 2017 Leanplum States
           WHERE position('4844275773472768' in experiments)>0
           AND issession = 'true'
           AND user_install_time >= '2017-01-01' 
GROUP by user_id, variant
) as base
GROUP by 1


-- Extant Users

SELECT variant, 
       sum(total_players) as total_players,
       sum(retain_day_1) as d1,
       sum(retain_day_3) as d3,
       sum(retain_day_7) as d7,
       sum(retain_day_14) as d14,
       sum(retain_day_30) as d30,
       sum(retain_day_60) as d60,
       sum(retain_day_90) as d90
FROM
(
SELECT 
  user_id, count(distinct user_id) as total_players, CASE
                    WHEN position('5627025807900672' in experiments)>0 then 'control'
                    WHEN position('4608942045659136' in experiments)>0 then 'v1'
                    WHEN position('5755273566224384' in experiments)>0 then 'v2'
                    ELSE 'broken'
                END AS variant,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1 ELSE 0 END) as retain_day_90
FROM public.tbl_choices_lp_sessions_2017 --- 2017 Leanplum States
           WHERE position('4818362268647424' in experiments)>0
           AND issession = 'true'
           AND user_install_time >= '2017-01-01' 
GROUP by user_id, variant
) as base
GROUP by 1



-- Incent Ad AB Test (New Users)
SELECT date, variant, (1) as newusers,
       sum(total_players) as total_players,
       sum(retain_day_1) as d1,
       sum(retain_day_3) as d3,
       sum(retain_day_7) as d7,
       sum(retain_day_14) as d14,
       sum(retain_day_30) as d30,
       sum(retain_day_60) as d60,
       sum(retain_day_90) as d90
FROM
(
SELECT 
  user_id, date(user_install_time) as date, count(distinct user_id) as total_players, CASE
                    WHEN position('6007486832967680' in experiments)>0 then 'control'
                    WHEN position('6590671920824320' in experiments)>0 then 'v1'
                    WHEN position('5700056258707456' in experiments)>0 then 'v2'
                    ELSE 'broken'
                END AS variant,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60,
        MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1 ELSE 0 END) as retain_day_90
FROM public.tbl_choices_lp_sessions_201801  --- 2017 Leanplum States
           WHERE position('4844275773472768' in experiments)>0
           AND issession = 'true'
           AND user_install_time between '2017-12-01' and '2018-02-10'
GROUP by user_id, variant, date
) as base
GROUP by 1,2
ORDER by date desc








