-- Retention by Chapter (60 day) *added changes
SELECT num_chapters_played, SUM(retain_day_1) as d1_user, SUM(retain_day_3) as d3_user, 
SUM(retain_day_7) as r7_user, SUM(retain_day_14) as r14_user, SUM(retain_day_21) as r21_user, SUM(retain_day_30) as r30_user, SUM(retain_day_60) as r60_user
FROM
(
SELECT MAX(num_unique_chapters_played) as num_chapters_played, MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60
FROM public.tbl_choices_lp_sessions
WHERE DATE(user_install_time) + INTERVAL '60 DAY' >= DATE(user_install_time)
AND num_unique_chapters_played in('0','1','2','3','4','5','6','7','10')
GROUP by user_id
)
GROUP by num_chapters_played
ORDER by num_chapters_played asc


-- Retention by Chapter (120 day)
SELECT num_chapters_played, SUM(retain_day_1) as d1_user, SUM(retain_day_3) as d3_user, 
SUM(retain_day_7) as r7_user, SUM(retain_day_14) as r14_user, SUM(retain_day_21) as r21_user, 
SUM(retain_day_30) as r30_user, SUM(retain_day_60) as r60_user, SUM(retain_day_90) as r90_user,
SUM(retain_day_120) as r120_user
FROM
(
SELECT MAX(num_unique_chapters_played) as num_chapters_played, MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1 ELSE 0 END) as retain_day_90,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=120 THEN 1 ELSE 0 END) as retain_day_120
FROM public.tbl_choices_lp_sessions
WHERE DATE(user_install_time) + INTERVAL '120 DAY' >= DATE(user_install_time)
AND num_unique_chapters_played in('0','1','2','3','4','5','6','7','10')
GROUP by user_id
)
GROUP by num_chapters_played
ORDER by num_chapters_played asc


-- Retention by Chapter (180 day)
SELECT num_chapters_played, SUM(retain_day_1) as d1_user, SUM(retain_day_3) as d3_user, 
SUM(retain_day_7) as r7_user, SUM(retain_day_14) as r14_user, SUM(retain_day_21) as r21_user, 
SUM(retain_day_30) as r30_user, SUM(retain_day_60) as r60_user, SUM(retain_day_90) as r90_user,
SUM(retain_day_120) as r120_user, SUM(retain_day_180) as r180_user
FROM
(
SELECT MAX(num_unique_chapters_played) as num_chapters_played, MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1 ELSE 0 END) as retain_day_1,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1 ELSE 0 END) as retain_day_3,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1 ELSE 0 END) as retain_day_7,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1 ELSE 0 END) as retain_day_14,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1 ELSE 0 END) as retain_day_21,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1 ELSE 0 END) as retain_day_30,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1 ELSE 0 END) as retain_day_60,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1 ELSE 0 END) as retain_day_90,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=120 THEN 1 ELSE 0 END) as retain_day_120,
MAX(CASE WHEN DATEDIFF('day', user_install_time, sessiontime)=180 THEN 1 ELSE 0 END) as retain_day_180,
FROM public.tbl_choices_lp_sessions
WHERE DATE(user_install_time) + INTERVAL '180 DAY' >= DATE(user_install_time)
AND num_unique_chapters_played in('0','1','2','3','4','5','6','7','10')
GROUP by user_id
)
GROUP by num_chapters_played
ORDER by num_chapters_played asc


#Aggregated Version

SELECT num_chapters_played,
       SUM(retain_day_1) AS d1_user,
       SUM(retain_day_3) AS d3_user,
       SUM(retain_day_7) AS r7_user,
       SUM(retain_day_14) AS r14_user,
       SUM(retain_day_21) AS r21_user,
       SUM(retain_day_30) AS r30_user,
       SUM(retain_day_60) AS r60_user,
       SUM(retain_day_90) AS r90_user
FROM
  (SELECT MAX(num_unique_chapters_played) AS num_chapters_played,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=1 THEN 1
                  ELSE 0
              END) AS retain_day_1,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=3 THEN 1
                  ELSE 0
              END) AS retain_day_3,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=7 THEN 1
                  ELSE 0
              END) AS retain_day_7,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=14 THEN 1
                  ELSE 0
              END) AS retain_day_14,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=21 THEN 1
                  ELSE 0
              END) AS retain_day_21,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=30 THEN 1
                  ELSE 0
              END) AS retain_day_30,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=60 THEN 1
                  ELSE 0
              END) AS retain_day_60,
          MAX(CASE
                  WHEN DATEDIFF('day', user_install_time, sessiontime)=90 THEN 1
                  ELSE 0
              END) AS retain_day_90
   FROM public.tbl_choices_lp_sessions
   WHERE DATE(user_install_time) + INTERVAL '90 DAY' >= DATE(user_install_time)
     AND num_unique_chapters_played in('0',
                                       '1',
                                       '2',
                                       '3',
                                       '4',
                                       '5',
                                       '6',
                                       '7',
                                       '10')
   GROUP BY user_id)
GROUP BY num_chapters_played
ORDER BY num_chapters_played ASC

   GROUP BY user_id)
GROUP BY num_chapters_played
ORDER BY num_chapters_played ASC

