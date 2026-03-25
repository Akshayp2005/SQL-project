use f_project;
-- Shows which user interacted with which ad under which campaign.
SELECT 
    u.user_id,
    a.ad_id,
    c.campaign_id,
    c.camp_name,
    e.time_stamp
FROM users u
JOIN ad_event e 
ON u.user_id = e.user_id
JOIN ads a 
ON e.ad_id = a.ad_id
JOIN campaign c 
ON a.campaign_id = c.campaign_id;


--  Top 5 Best Performing Ads
SELECT 
    a.ad_id,
    COUNT(e.event_id) AS total_events
FROM ads a
 inner JOIN ad_event e 
    ON a.ad_id = e.ad_id
GROUP BY a.ad_id
ORDER BY total_events DESC
LIMIT 5;

-- Compare location-wise Ad Interaction, which have more then 3 interaction

SELECT 
    u.location,
    COUNT(e.event_id) AS total_interactions
FROM users u
JOIN ad_event e 
    ON u.user_id = e.user_id
GROUP BY u.location
having 3< total_interactions
ORDER BY total_interactions DESC; 

--  AVG OF EVENT_TYPE

SELECT count(event_id), event_type AS total_events
FROM ad_event
GROUP BY event_type;


--  Average events per day


SELECT AVG(daily_events) AS avg_events_per_day
FROM (
    SELECT DATE(time_stamp) AS event_date,
           COUNT(*) AS daily_events
    FROM ad_event
    GROUP BY DATE(time_stamp)
)  s;


 -- Compare Age Group Performance( each age group have how many event) or( find the age group that have max event)

SELECT 
    u.age_group,
    COUNT(e.event_id) AS total_events
FROM users u
JOIN ad_event e 
    ON u.user_id = e.user_id
GROUP BY u.age_group
ORDER BY total_events DESC; 

--  CTR (Click Through Rate) (CTR=(TotalClicks/TotalImpressions)*100)
SELECT 
    c.campaign_id,
    c.camp_name,
    
    SUM(CASE WHEN e.event_type = 'click' THEN 1 ELSE 0 END) AS total_clicks,
    
    SUM(CASE WHEN e.event_type = 'impression' THEN 1 ELSE 0 END) AS total_impressions,
    
    ROUND(
        (SUM(CASE WHEN e.event_type = 'click' THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(SUM(CASE WHEN e.event_type = 'impression' THEN 1 ELSE 0 END),0),
    2) AS CTR_Percentage

FROM campaign c
JOIN ads a ON c.campaign_id = a.campaign_id
JOIN ad_event e ON a.ad_id = e.ad_id
GROUP BY c.campaign_id, c.camp_name
 ORDER BY CTR_Percentage DESC;
 
 -- ROI (Return on Investment) (ROI=((Revenue−Cost)/Cost)*100))
 SELECT 
    c.campaign_id,
    c.camp_name,
    
    SUM(c.total_revenue) ,
    SUM(c.total_cost) ,
    
    ROUND(
        ((SUM(c.total_revenue) - SUM(c.total_cost)) * 100.0) /
        NULLIF(SUM(c.total_cost),0),
    2) AS ROI_Percentage

FROM campaign c
GROUP BY c.campaign_id, c.camp_name
ORDER BY ROI_Percentage DESC;
