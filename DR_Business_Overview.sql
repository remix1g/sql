-- depend on dr_MAU
begin

drop table if exists dr_agg.dbo.business_overview
select * into dr_agg.dbo.business_overview
from
(
        select a.activity_date
                , a.DAU
                , m.player_MAU as MAU
                , total_revenue
                , payers
                , churned_payers
                , churned
                , installs
                , lifetime_revenue
                , D1_player
                , D7_player
                , D14_player
                , D30_player
                , 'Player_based' as data_source
        from
        (
                select activity_date
                , count(distinct player_id) as DAU
                , sum(revenue) as total_revenue
                , count(distinct case when is_payer=1 then player_id end) as payers
                --, count(distinct case when is_payer=1 then player_id end)/count(distinct player_id) as payer_rate
                , count(distinct case when b.npsn is not null and is_payer=1 then player_id end) as churned_payers
                , count(distinct case when b.npsn is not null then player_id end) as churned
                --, count(distinct case when b.npsn is not null then player_id end)/count(distinct player_id) as churned_rate
                from dr_agg.dbo.sum_daily_player_details a
                left join dr_agg.dbo.churn_npsn b on a.player_id=b.npsn and a.activity_date=convert(date, last_login)
                group by activity_date
        )a
        left join
        (
                select install_date
                , count(distinct player_id) as installs
                , sum(revenue) as lifetime_revenue
                , count(distinct case when datediff(day,install_date, activity_date)=1 then player_id end) as D1_player
                , count(distinct case when datediff(day,install_date, activity_date)=7 then player_id end) as D7_player
                , count(distinct case when datediff(day,install_date, activity_date)=14 then player_id end) as D14_player
                , count(distinct case when datediff(day,install_date, activity_date)=30 then player_id end) as D30_player
                from dr_agg.dbo.sum_daily_player_details a
                group by install_date
        )i
        on a.activity_date=i.install_date
        left join dr_agg.dbo.player_MAU as m
        on a.activity_date=m.activity_date
        
        union all
        
        select a.activity_date
                , a.DAU
                , m.device_MAU as MAU
                , total_revenue
                , payers
                , churned_payers
                , churned
                , installs
                , lifetime_revenue
                , D1_player
                , D7_player
                , D14_player
                , D30_player
                , 'Device_based' as data_source
        from
        (
                select activity_date
                , count(distinct device_id) as DAU
                , sum(revenue) as total_revenue
                , count(distinct case when is_payer=1 then device_id end) as payers
                , count(distinct case when b.adid is not null and is_payer=1 then device_id end) as churned_payers
                , count(distinct case when b.adid is not null then device_id end) as churned
                from dr_agg.dbo.sum_daily_device_details a
                left join dr_agg.dbo.churn_adid b on a.device_id=b.adid and a.activity_date=convert(date, last_login)
                group by activity_date
        )a
        left join
        (
                select install_date
                , count(distinct device_id) as installs
                , sum(revenue) as lifetime_revenue
                , count(distinct case when datediff(day,install_date, activity_date)=1 then device_id end) as D1_player
                , count(distinct case when datediff(day,install_date, activity_date)=7 then device_id end) as D7_player
                , count(distinct case when datediff(day,install_date, activity_date)=14 then device_id end) as D14_player
                , count(distinct case when datediff(day,install_date, activity_date)=30 then device_id end) as D30_player
                from dr_agg.dbo.sum_daily_device_details a
                group by install_date
        )i
        on a.activity_date=i.install_date
        left join dr_agg.dbo.device_MAU as m
        on a.activity_date=m.activity_date
) as t

end;