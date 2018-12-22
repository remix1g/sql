select base3.opponent_win, base3.my_win, base3.date
from
(
	select date(db_ts) as date,count(distinct player_d_skey) as dau, count(distinct etl_ts) as app_opens
	from prod.launch
	group by date
	order by date desc
) as base

left join

(
	select date(install_date) as install_date, sum(installs) as installs, sum(actives_1) as active1, sum(actives_3) as active3, sum(actives_7) as active7, sum(actives_14) as active14, sum(actives_21) as active21, sum(actives_30) as active30
	from agg_dashboard.rpt_daily_device_install
	group by install_date
) as base2

ON base.date = base2.install_date

left join

(
  select date(db_ts) as date, avg(c_match_duration) as avg_match, case when c_opp_creature_killed>=3 then 1 else 0 end as opponent_win, case when c_my_creature_lost >=3 then 1 else 0 end as my_win
  from prod.c_pvp_result_game_client
  group by date, c_opp_creature_killed, c_my_creature_lost
) as base3

ON base2.install_date = base3.date

#Original win/loss query
  select date(db_ts) as date, avg(c_match_duration) as avg_match, case when c_opp_creature_killed>=3 then 1 else 0 end as opponent_win, case when c_my_creature_lost >=3 then 1 else 0 end as my_win
  from prod.c_pvp_result_game_client
  group by date, c_opp_creature_killed, c_my_creature_lost

# adding in c_opp_medal_cnt -- don't look at 
	select date(db_ts) as date, avg(c_match_duration) as avg_match, sum(c_opp_medal_cnt) as opp_count, sum(c_my_medal_cnt) as my_count,
	case
	when c_my_medal_cnt > 1 then 'win'
	else 'lose_medal'
	end as medal_count
	from prod.c_pvp_result_game_client
	group by date, c_my_medal_cnt

cross join

	select date(db_ts) as date, sum(c_my_medal_cnt) as my_count, sum(c_opp_medal_cnt) as opp_cnt
	from prod.c_pvp_result_game_client
	group by date

union

	select c_opp_creature_killed, case when c_opp_creature_killed >= 3 then 1
	else '0'
	end as win_count, case when c_my_creature_lost >=3 then '1
	else '0'
	end as win_count_my
	from prod.c_pvp_result_game_client


## Case when Statements tool
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=1 THEN 1 ELSE 0 END) as retain_day_1,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=2 THEN 1 ELSE 0 END) as retain_day_2,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=3 THEN 1 ELSE 0 END) as retain_day_3,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=4 THEN 1 ELSE 0 END) as retain_day_4,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=5 THEN 1 ELSE 0 END) as retain_day_5,
MAX(CASE WHEN DATEDIFF('day',player_create_day, day)=7 THEN 1 ELSE 0 END) as retain_day_7,





