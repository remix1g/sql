--PRE-POST behavior - rev, ads watched, sessions, chapters finished
--------------------------------------------------------------------
SELECT segment, 
      variant, 
      usersystem, 
      country, 
      DATEDIFF(day, date_joined_test, date_of_agg) as days_since_joined_test, 
      count(x.user_id) as players, 
      AVG(daily_sessions * 1.0) as avg_daily_sessions, AVG(ttl_ads_viewed * 1.0) as avg_ads_viewed, SUM(opt_out) as ttl_opt_out,
      AVG(ttl_prem_choices * 1.0) as avg_prem_choices, AVG(chap_finished * 1.0) as avg_chap_finished, AVG(chap_repeated * 1.0) as avg_chap_repeated,
      AVG(books * 1.0) as avg_books_started, AVG(ttl_value * 1.0) as avg_ttl_value
    FROM 
    (  --Master list of participants
      SELECT user_id, MIN(sessiontime) as date_joined_test
          country, 
          CASE WHEN usersystem = 'iOS' OR usersystem = 'iPhone OS' THEN 'iOS' ELSE usersystem END, 
          
          CASE 
           WHEN position('4818362268647424' in experiments)>0 THEN 'Extants'
           WHEN position('4844275773472768' in experiments)>0 THEN 'New'
           ELSE 'poppycock' 
           END AS segment,
          
          CASE  
           WHEN (position('6007486832967680' in experiments)>0 OR position('5627025807900672' in experiments)>0) THEN 'Control' 
           WHEN (position('6590671920824320' in experiments)>0 OR position('4608942045659136' in experiments)>0) THEN 'Incent Only' 
           WHEN (position('5700056258707456' in experiments)>0 OR position('5755273566224384' in experiments)>0) THEN 'Hybrid' 
           ELSE 'poppycock' END AS variant,

      FROM public.tbl_choices_lp_sessions 
          WHERE (position('4818362268647424' in experiments)>0 OR position('4844275773472768' in experiments)>0)
          AND usersystem IS NOT NULL
          AND country IN ('AU', 'NZ') AND sessiontime >= '2018-01-16' --date of test start
          GROUP BY 1, 2, 3, 4, 5
    ) x   
    LEFT JOIN 



axe_analysis_char_play_info { /* last connected date, total_payment_info */
    int user_partition;
    character nick;
    int guild_no;
    string master_id;
    int domain_id;
    string user_no;
    string char_no;
    string character_index;


contract { 
address _owner
uint user_partition;
uint guild_no;
uint domain_id;
uint char_no;
}

constructor(uint, _owner, _input1, _input2, _input3) {
  input1 = msg.sender
  input2 = _input1
  input3 = _input2
}
}



select 
from 
(
select date(date_last_connect) as new_date, char_lv, character_index
FROM axe_analysis_char_play_info group by new_date, char_lv
order by char_lv asc 
) as b1

left join

(
select sum(play_time) as play_time, sum(use_vigor) as vigor, sum(total_play_time) as play_time, sum(total_use_vigor) as total_vigor, sum(total_paid_amount) as total_amount, sum(total_paid_count) as total_count, sum(last_paid_amount) as last_paid_amount
FROM axe_analysis_char_play_info 
limit 4
) as b2 


    /**
    ( --In-game behavior
      SELECT user_id, DATE_TRUNC('day', sessiontime) as date_of_agg, COUNT(distinct sessionid) as daily_sessions, MAX(num_ads_viewed) as ttl_ads_viewed,
           MAX(num_premium_choices_purchased) as ttl_prem_choices, 
           MAX(num_books_started) as books, MAX(total_value) as ttl_value,
           MAX(num_unique_chapters_played) as chap_finished,
           MAX(num_chapters_played) - MAX(num_unique_chapters_played) as chap_repeated
       FROM public.tbl_choices_lp_sessions 
           WHERE sessiontime >= '2018-01-11' --earliest agg window possible
      GROUP BY 1, 2
              ) a ON x.user_id = a.user_id
    LEFT JOIN 
    (
      SELECT user_id, DATE_TRUNC('day', MIN(event_time)) as date_of_opt_out, 1 as opt_out
          FROM public.tbl_choices_lp_events 
              WHERE event = 'incent_ad_opt_out'
              AND event_time >= '2018-01-16' --date of test start
      GROUP BY 1 
              ) b ON a.user_id = b.user_id AND a.date_of_agg = b.date_of_opt_out
    GROUP BY 1, 2, 3, 4, 5 ORDER BY 5 ASC
*/



