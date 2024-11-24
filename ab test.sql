WITH events AS (SELECT 
                    LEFT(event_date, 6) AS month,
                    campaign,
                    COUNT(DISTINCT user_pseudo_id) AS user_count
                FROM tc-da-1.turing_data_analytics.raw_events
                WHERE event_name = 'page_view'
                      AND ((campaign IN ('NewYear_V1','NewYear_V2') AND LEFT(event_date, 6) = '202101')
                          OR (campaign IN ('BlackFriday_V1','BlackFriday_V2') AND LEFT(event_date, 6) = '202011'))
                GROUP BY 1,2),
     adsense AS (SELECT * 
                 FROM tc-da-1.turing_data_analytics.adsense_monthly
                 WHERE Campaign IN ('NewYear_V1','NewYear_V2','BlackFriday_V1','BlackFriday_V2')
                 AND (Month = 202101 OR Month = 202011))

SELECT
      adsense.Month,
      adsense.Campaign,
      adsense.Impressions,
      events.user_count,
      ROUND(events.user_count/adsense.Impressions,4) AS conversion_rate
FROM adsense
    JOIN events
        ON adsense.Campaign = events.campaign AND CAST(adsense.Month AS STRING) = events.month;