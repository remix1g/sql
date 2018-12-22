SELECT date, 
             
             category, book,
             chapter, category,
             chapter_starts,
             chapter_completions,
             choice,
             purchases,
             paid_diamonds_spent,
             total_diamonds_spent,
             chapter_completions * 1.0 / chapter_starts * 1.0 AS chapter_completion_percentage,
             purchases * 1.0 / chapter_starts * 1.0 AS choice_conversion_percentage,
             paid_diamonds_spent * 1.0 / chapter_starts * 1.0 AS paid_diamonds_per_chapter_start,
             paid_diamonds_spent * 1.0 / purchases * 1.0 AS paid_diamonds_per_purchase,
             sum(purchases) over (partition BY date, book) AS total_purchases_in_book,
             sum(paid_diamonds_spent) over (partition BY date, book) AS total_diamonds_spent_in_book,
             purchases * 1.0 / sum(purchases) over (partition BY date, book) * 1.0 AS percent_of_total_book_purchases_from_this_choice,
             paid_diamonds_spent * 1.0 / sum(paid_diamonds_spent) over (partition BY date, book) * 1.0 AS percent_of_total_book_diamonds_from_this_choice
FROM
  (SELECT date, book,
                CASE
                    WHEN choice ilike '%_outfit_0%' then ltrim(split_part(choice, '_', 5),'0') --newer choices designated as outfits. comes first because it's most specific and these clauses run in order.
 
                    WHEN choice ilike '%0%' then ltrim(split_part(choice, '_', 4),'0') --newer choices
 
                    ELSE split_part(chapter, ':', 2) --older chapters
 
                END AS chapter, 
                CASE 
                    WHEN choice ilike '%_outfit_0%' then substring(choice 
                                                                   FROM 26) 
                    WHEN choice ilike '%0%' then substring(choice 
                                                           FROM 19) 
                    ELSE choice 
                END AS choice,
   CASE
                    when book ilike '%adventure_endless_summer%' then 'Endless Summer'
                    when book ilike '%romance_the_freshman%' then 'The Freshman'
                    when book ilike '%adventure_hero%' then 'Hero'
                    when book ilike '%chat_horror_graveyard_tales%' then 'Graveyard Tales'
                    when book ilike '%chat_horror_knock_knock%' then 'Knock Knock'
                    when book ilike '%chat_horror_mommy_dearest%' then 'Mommy Dearest'
                    when book ilike '%chat_horror_the_shadow%' then 'The Shadow'
                    when book ilike '%chat_horror_zombie_dispatch%' then 'Zombie Dispatch'
                    when book ilike '%chat_horror_the_shadow%' then 'The Shadow'
                    when book ilike '%chat_romance_kiss_and_tell%' then 'Kiss and Tell'
                    when book ilike '%chat_romance_love_stories%' then 'Love Stories'
                    when book ilike '%chat_romance_love_takes_time%' then 'Love Takes Time'
                    when book ilike '%crime_most_wanted%' then 'Crime Most Wanted'
                    when book ilike '%fantasy_the_crown_and_the_flame%' then 'The Crown and The Flame'
                    when book ilike '%horror_it_lives_in_the_woods%' then 'It lives in the Woods'
                    when book ilike '%horror_the_haunting_of_braidwood_manor%' then 'The Haunting of Braidwood Manor'
                    when book ilike '%romance_high_school_story%' then 'Highschool Story'
                    when book ilike '%romance_home_for_the_holidays%' then 'Home for the Holidays'
                    when book ilike '%romance_lovehacks%' then 'Lovehacks'
                    when book ilike '%romance_rules_of_engagement%' then 'Rules of Engagement'
                    when book ilike '%romance_red_carpet_diaries%' then 'Red Carpet Diaries'
                    when book ilike '%test_chapter_replay%' then 'Test Chapter Replay'
                    when book ilike '%romance_perfect_match%' then 'Perfect Match'
                    when book ilike '%romance_the_sophomore%' then 'The Sophomore'
                    when book ilike '%romance_the_royal_romance%' then 'Royal Romance'
                    when book ilike '%chat_horror_graveyard_tales%' then 'Chat Graveyard Tales'
                    when book ilike '%chat_horror_knock_knock%' then 'Chat Knock Knock'
                    else 'non_category'
                    end as category,
                count(choice) AS purchases, 
                sum(paid_diamonds_spent) AS paid_diamonds_spent,
                max(paid_diamonds_spent) as total_diamonds_spent
   FROM ( 
           (SELECT trunc(event_time) AS date, user_id
                   split_part(json_extract_path_text(parameters, 'choice_key'), ':', 2) AS choice, 
                   split_part(json_extract_path_text(parameters, 'choice_key'), ':', 1) AS book, 
                   json_extract_path_text(parameters, 'paid_diamonds_spent') AS paid_diamonds_spent
            FROM public.tbl_choices_lp_events 
              where  json_extract_path_text(parameters, 'paid_diamonds_spent') > 0) events
         left join --chapter map for choices in older books, which do not have chapters in their param strings
 
           (SELECT lower(chapter_key) AS chapter, 
                   lower(choice_key) AS choice 
            FROM public.tbl_choices_lp_resources_chapter_premium_choice_map) map using (choice)
           )
   GROUP BY 1, 
            2, 
            3, 
            4,
            5) choices
            
right join --chapter starts and finishes
 
  (SELECT trunc(event_time) AS date, 
          split_part(json_extract_path_text(parameters, 'chapter_key'),':',1) AS book, 
          split_part(json_extract_path_text(parameters, 'chapter_key'),':',2) AS chapter, 
          sum(CASE 
                  WHEN event = 'chapter_started' then 1 
              END) AS chapter_starts, 
          sum(CASE 
                  WHEN event = 'chapter_finished' then 1 
              END) AS chapter_completions 
   FROM public.tbl_choices_lp_events 
   WHERE (event = 'chapter_started'
          OR event = 'chapter_finished') 
   GROUP BY 1, 
            2, 
            3) starts using (date, book, 
                                   chapter)

WHERE date >= '2017-05-01'
ORDER BY 1 DESC,
         2,
         3,
         4




SELECT date, count(distinct choice) as purchases, count(choice) as purchases2
FROM
(
SELECT trunc(event_time) AS date, user_id,
            split_part(json_extract_path_text(parameters, 'choice_key'), ':', 1) AS book,
           split_part(json_extract_path_text(parameters, 'choice_key'), ':', 2) AS choice
            FROM public.tbl_choices_lp_events 
            WHERE event = 'purchased_premium_choice'
            GROUP by 1,2,3,4
)GROUP by 1



