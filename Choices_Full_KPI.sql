SELECT nvl(monthly.platform,ad_spend.platform) platform,
       nvl(monthly.cohort_date,ad_spend.cohort_date) cohort_date,
       nvl(monthly.country,ad_spend.country) country,
       isnull(SUM(monthly.cohort_size),0) AS cohort_size,
       isnull(SUM(monthly.paid_installs),0) AS paid_installs,
       isnull(SUM(monthly.cohort_size),0) - isnull(SUM(monthly.paid_installs),0) AS organic_installs,
       isnull(SUM(monthly.cross_promo_installs),0) AS cross_promo_installs,
       isnull(SUM(monthly.revenue)/100.0,0) AS total_revenue,
       isnull(SUM(monthly.paid_revenue)/100.0,0) AS paid_revenue,
       isnull(SUM(monthly.revenue)/100.0,0) - isnull(SUM(monthly.paid_revenue)/100.0,0) AS organic_revenue,
       isnull(SUM(monthly.d0_retained_users),0) AS d0_retained_users,
       isnull(SUM(monthly.d0_revenue)/100.0,0) AS d0_revenue,
       isnull(SUM(monthly.d1_retained_users),0) AS d1_retained_users,
       isnull(SUM(monthly.d1_revenue)/100.0,0) AS d1_revenue,
       isnull(SUM(monthly.d3_retained_users),0) AS d3_retained_users,
       isnull(SUM(monthly.d3_revenue)/100.0,0) AS d3_revenue,
       isnull(SUM(monthly.d7_retained_users),0) AS d7_retained_users,
       isnull(SUM(monthly.d7_revenue)/100.0,0) AS d7_revenue,
       isnull(SUM(monthly.d14_retained_users),0) AS d14_retained_users,
       isnull(SUM(monthly.d14_revenue)/100.0,0) AS d14_revenue,
       isnull(SUM(dailyinfo.DAU),0) AS DAU,
       isnull(SUM(dailyinfo.daily_iap_revenue)/100.0,0) AS daily_iap_revenue,
       SUM(monthly.revenue) / nullif(SUM(monthly.cohort_size),0) AS current_lifetime_value,
       isnull(SUM(lifetime.lifetime_payer_count),0) AS lifetime_payer_count,
       isnull(SUM(dailyadrevenue.daily_ad_revenue),0) + isnull(SUM(dailyinfo.daily_iap_revenue)/100.0,0) AS total_daily_revenue,
       isnull(SUM(cohortedadrev.estimated_geo_allocated_ad_revenue),0) AS total_ad_revenue,
       isnull(SUM(cohortedadrev.organic_allocated_ad_revenue),0) AS organic_ad_revenue,
       isnull(SUM(cohortedadrev.paid_allocated_ad_revenue),0) AS paid_ad_revenue,
       SUM(dailyadrevenue.daily_ad_revenue) AS daily_ad_revenue      -- already divided by 100.0 in table  
FROM (SELECT cohort_date,
             country,
             platform,
             SUM(cohort_size) cohort_size,
             SUM(current_lifetime_revenue) revenue,
             SUM(paid_installs) paid_installs,
             SUM(cross_promo_installs) cross_promo_installs,
             SUM(paid_revenue) paid_revenue,
             SUM(d0_retained_users) d0_retained_users,
             SUM(d0_revenue) d0_revenue,
             SUM(d1_retained_users) d1_retained_users,
             SUM(d1_revenue) d1_revenue,
             SUM(d3_retained_users) d3_retained_users,
             SUM(d3_revenue) d3_revenue,
             SUM(d7_retained_users) d7_retained_users,
             SUM(d7_revenue) d7_revenue,
             SUM(d14_retained_users) d14_retained_users,
             SUM(d14_revenue) d14_revenue,
             SUM(d30_retained_users) d30_retained_users,
             SUM(d30_revenue) d30_revenue,
             SUM(d60_retained_users) d60_retained_users,
             SUM(d60_revenue) d60_revenue,
             SUM(d90_retained_users) d90_retained_users,
             SUM(d90_revenue) d90_revenue,
             SUM(d120_retained_users) d120_retained_users,
             SUM(d120_revenue) d120_revenue,
             SUM(d150_retained_users) d150_retained_users,
             SUM(d150_revenue) d150_revenue,
             SUM(d180_retained_users) d180_retained_users,
             SUM(d180_revenue) d180_revenue
      FROM public.tbl_choices_tenjin_cohort_revenues 
       WHERE cohort_date >= '2016-07-11'
      GROUP BY cohort_date,
               country, platform) monthly
  LEFT OUTER JOIN (SELECT DATE,
                          country,
                          CASE
                            WHEN b.app_id = 'ca3196d1-7bfd-4e86-be1a-226300751aae' THEN 'ios'
                            ELSE 'android'
                          END platform,
                          SUM(users) DAU,
                          SUM(monthly_users) MAU,
                          SUM(revenue) AS daily_iap_revenue
                   FROM TBL_pb_tenjin_daily_behavior a
                     JOIN public.tbl_pb_tenjin_campaigns b ON a.campaign_id = b.id
                   WHERE app_id IN ('ca3196d1-7bfd-4e86-be1a-226300751aae','ab92f62c-7f5a-42c5-b8ea-2b97bcd148b9')
                   GROUP BY 1,
                            2,
                            3) dailyinfo
               ON monthly.cohort_date = dailyinfo.date
              AND monthly.country = dailyinfo.country
              AND monthly.platform = dailyinfo.platform
  LEFT OUTER JOIN (select date, country, platform, sum(mau) mau from public.tbl_choices_tenjin_mau group by 1,2,3) mau
                ON monthly.cohort_date = mau.date
              AND monthly.country = mau.country
              AND monthly.platform = mau.platform
  FULL OUTER JOIN (SELECT cohort_date,
                          country,
                          platform,
                          SUM(improved_tableau_spend) AS improved_tableau_spend,
                          SUM(bidalgo_managed_facebook_spend * bidalgo_fee)/100 AS bidalgo_fee_facebook,
                          SUM(bidalgo_managed_google_spend * bidalgo_fee)/100 AS bidalgo_fee_google,
                          SUM(bidalgo_managed_pinterest_spend)/100 AS bidalgo_fee_pinterest,
                          SUM(bidalgo_managed_apple_search_spend * bidalgo_fee)/100 AS bidalgo_fee_apple_search_ads,
                          SUM(bidalgo_managed_snapchat_spend)/100 AS bidalgo_fee_snapchat,
                          SUM(grow_managed_spend * bidalgo_fee)/100 AS grow_fee
                    FROM (
                        SELECT cohort_date, 
                               DATE_TRUNC('month', cohort_date) AS cohort_month,
                               platform,
                               country,
                               improved_tableau_spend,
                               bidalgo_managed_facebook_spend,
                               bidalgo_managed_google_spend,
                               grow_managed_spend,
                               bidalgo_managed_pinterest_spend,     
                               bidalgo_managed_apple_search_spend,
                               bidalgo_managed_snapchat_spend  
                        FROM public.tbl_choices_tenjin_cohort_ad_spend s
                        ) spend
                    LEFT JOIN (SELECT cohort_month,
                                       CASE 
                                            WHEN COALESCE(LAG(bidalgo_spend, 1) OVER (ORDER BY cohort_month), 0) < 800000 THEN 0.1765
                                            WHEN COALESCE(LAG(bidalgo_spend, 1) OVER (ORDER BY cohort_month), 0) BETWEEN 800000 AND 1499999 THEN 0.15
                                            WHEN COALESCE(LAG(bidalgo_spend, 1) OVER (ORDER BY cohort_month), 0) BETWEEN 1499999 AND 1999999 THEN 0.14
                                            WHEN COALESCE(LAG(bidalgo_spend, 1) OVER (ORDER BY cohort_month), 0) BETWEEN 2000000 AND 2499999 THEN 0.135
                                            WHEN COALESCE(LAG(bidalgo_spend, 1) OVER (ORDER BY cohort_month), 0) > 2500000 THEN 0.13
                                    END AS bidalgo_fee
                                    FROM 
                                            (SELECT cohort_month,
                                                       SUM(CASE 
                                                               WHEN ad_network_id IN (3, 5, 63, 116, 83, 169) AND campaign_name ILIKE '%bidalgo%' THEN improved_tableau_spend
                                                               ELSE 0 
                                                       END) AS bidalgo_spend
                                                    FROM (
                                                            SELECT DATE_TRUNC('month', date) AS cohort_month,
                                                                               c.name AS campaign_name,
                                                                               ad_network_id,
                                                                               n.name AS network,
                                                                               sum(spend * 1.00 * CASE
                                                                                            WHEN u.campaign_id is not null then new_users
                                                                                            ELSE 1
                                                                                            END/ CASE
                                                                                                 WHEN u.campaign_id is not null then campaign_day_users
                                                                                                 ELSE 1
                                                                                         END) / 100 AS improved_tableau_spend                                 
                                                                FROM tbl_pb_tenjin_daily_spend s
                                                                LEFT JOIN
                                                                        (SELECT acquired_at :: DATE AS date,
                                                                          nvl(country,'zz') as country,
                                                                          source_campaign_id AS campaign_id,
                                                                          count(DISTINCT advertising_id) AS new_users,
                                                                          sum(count(distinct advertising_id)) over (partition BY acquired_at::date, source_campaign_id) AS campaign_day_users
                                                                           FROM tbl_pb_tenjin_events u1
                                                                           JOIN tbl_pb_tenjin_campaigns u2
                                                                                 ON u1.source_campaign_id=u2.id
                                                                           WHERE u1.app_id in ('ca3196d1-7bfd-4e86-be1a-226300751aae','ab92f62c-7f5a-42c5-b8ea-2b97bcd148b9')
                                                                                 AND event = 'open'
                                                                                 AND datediff('sec', acquired_at, created_at) < 86400
                                                                           GROUP BY 1,2,3) u 
                                                                        USING (date, campaign_id)
                                                                LEFT JOIN  tbl_pb_tenjin_campaigns c
                                                                            ON s.campaign_id = c.id
                                                                    LEFT JOIN tbl_pb_tenjin_ad_networks n 
                                                                                    ON c.ad_network_id = n.id
                                                                WHERE c.app_id IN ('ca3196d1-7bfd-4e86-be1a-226300751aae','ab92f62c-7f5a-42c5-b8ea-2b97bcd148b9')
                                                                            AND date >= '2016-08-17'
                                                                GROUP BY 1,2,3,4
                                                                ) tmp
                                                    GROUP BY 1
                                                    ) tmp
                                            ) fee 
                            USING (cohort_month)
            GROUP BY 1,2,3
            ) ad_spend 
                on monthly.cohort_date=ad_spend.cohort_date
                and monthly.country=ad_spend.country
                and monthly.platform=ad_spend.platform
  LEFT OUTER JOIN (SELECT DATE cohort_date, COUNTRY, PLATFORM, SUM(PAYERS) lifetime_payer_count from public.tbl_choices_tenjin_cohort_behavior_lifetime
          group by 1,2,3 )lifetime 
        on monthly.cohort_date=lifetime.cohort_date
                and monthly.country=lifetime.country
                and monthly.platform=lifetime.platform 
  LEFT OUTER JOIN public.tbl_choices_tenjin_daily_ad_revenue dailyadrevenue 
        on monthly.cohort_date=dailyadrevenue.date
                and monthly.country=dailyadrevenue.country
                and monthly.platform=dailyadrevenue.platform 
  LEFT OUTER JOIN public.tbl_choices_tenjin_cohort_ad_revenues  cohortedadrev 
        on monthly.cohort_date=cohortedadrev.cohort_date
                and monthly.country=cohortedadrev.country
                and monthly.platform=cohortedadrev.platform 
  LEFT OUTER JOIN 
  (SELECT date, 
            platform,
             country,
             count(distinct(case when week_after_install = 3 then advertising_id end)) as week_3_users,
            count(distinct(case when week_after_install = 4 then advertising_id end)) as week_4_users
            -- week_after_install,
            -- COUNT(DISTINCT advertising_id) retained_users
      FROM (SELECT case when app_id = 'ca3196d1-7bfd-4e86-be1a-226300751aae' then 'ios'
                  else 'android' end as platform,
                  country,
                  coalesce(nullif(advertising_id, ''), developer_device_id) AS advertising_id,
                   trunc(acquired_at) as date,
                   created_at,
                   datediff(week,acquired_at,created_at) AS week_after_install
            FROM tbl_pb_tenjin_events
            WHERE event = 'open'
            AND   app_id in ('ca3196d1-7bfd-4e86-be1a-226300751aae','ab92f62c-7f5a-42c5-b8ea-2b97bcd148b9')
            ) tmp
      where country != '' and (week_after_install >= 0 and week_after_install <= 4) and date >= '2016-07-11'
      GROUP BY date, platform, country
      ) weeklyret on 
        monthly.cohort_date=weeklyret.date
                and monthly.country=weeklyret.country
                and monthly.platform=weeklyret.platform 


GROUP BY 1,2,3