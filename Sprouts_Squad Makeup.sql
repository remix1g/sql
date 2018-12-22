
# Splitting Sprouts Squad through c_my_squad table
select c_my_squad, 
split_part(c_my_squad,'_',1) as squad_1, split_part(c_my_squad,'_',2) as squad_2,
split_part(c_my_squad,'_',3) as squad_3,
split_part(c_my_squad,'_',4) as squad_4,
split_part(c_my_squad,'_',5) as squad_5,
split_part(c_my_squad,'_',6) as squad_6,
split_part(c_my_squad,'_',7) as squad_7, c_match_duration, max(c_my_medal_cnt) as medal_count
from prod.c_pvp_result_game_client
group by c_my_squad, c_match_duration
)


# Squad Rank by Avg Duration
select c_my_squad,
(
select c_my_squad, 
split_part(c_my_squad,'_',1) as squad1_lvl, 
split_part(c_my_squad,'_',2) as squad2_lvl,
split_part(c_my_squad,'_',3) as squad3_lvl,
split_part(c_my_squad,'_',4) as squad_1,
split_part(c_my_squad,'_',5) as squad_2,
split_part(c_my_squad,'_',6) as squad_3,
split_part(c_my_squad,'_',7) as squad_7, 
split_part(c_my_squad,'_',8) as squad_8,
sum(c_match_duration) as match_duration, avg(c_match_duration) as avg_duration,
max(c_my_medal_cnt) as medal_count, 
max(player_level) as player_level, max(player_rank) as player_rank
from prod.c_pvp_result_game_client
group by c_my_squad, c_match_duration
limit 5;
) 
full join
(# Duration Time
	select date(db_ts) as date, c_my_squad, 
	split_part(c_my_squad,'_',1) as squad_1, split_part(c_my_squad,'_',2) as squad_2,
	split_part(c_my_squad,'_',3) as squad_3,
	split_part(c_my_squad,'_',4) as squad_4,
	split_part(c_my_squad,'_',5) as squad_5,
	split_part(c_my_squad,'_',6) as squad_6,
	split_part(c_my_squad,'_',7) as squad_7, c_match_duration, max(c_my_medal_cnt) as medal_count
	from prod.c_pvp_result_game_client
	group by c_my_squad, c_match_duration, date
) as base
union
(
# Clean Medal Count
	select player_d_skey, max(c_my_medal_cnt) as medal_count, max(c_opp_medal_cnt) as opponent_count, case
	when c_my_medal_cnt > 0 then 'win'
	else 'non_medal_count'
	end as non_medal_count, case when
	c_opp_medal_cnt > 0 then 'lose'
	end as lose
	from prod.c_pvp_result_game_client
	group by player_d_skey, c_opp_medal_cnt, c_my_medal_cnt
limit 15
) as base

select c_opp_user_id
from prod.c_pvp_result_game_client
group by c_opp_user_id
limit 100;



