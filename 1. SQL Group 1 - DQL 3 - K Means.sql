#The marketing department wants to identify the most profitable events based on their revenue and costs. 
#Additionally, they request a classification system to categorize events based on their profitability. 

# 1.1. CTE - Create the view
#		Create a new table with all the costs and revenues per event
CREATE VIEW budget AS SELECT
	ce.event_id,
    ce.event_name,
    ce.date_event,
    ce.concert_status,
	'Ticketing' as Entity,
    bt.ticketing_id as id,
    t.company_name as Name,
    bt.amount as amount
FROM eventsphere.concerts_events ce
JOIN eventsphere.budget_ticketing bt ON ce.event_id = bt.event_id
JOIN eventsphere.ticketing_platforms t ON bt.ticketing_id = t.ticketing_id

UNION ALL

SELECT
	ce.event_id,
    ce.event_name,
    ce.date_event,
    ce.concert_status,
    'Artist' as Entity,
    ba.artist_id as id,
    a.artist_name as Name,
    (ba.amount*-1) as amount
FROM eventsphere.concerts_events ce
JOIN eventsphere.budget_artists ba ON ce.event_id = ba.event_id
JOIN eventsphere.artists a ON ba.artist_id = a.artist_id

UNION ALL

SELECT
	ce.event_id,
    ce.event_name,
    ce.date_event,
    ce.concert_status,
    'Sponsor' as Entity,
    bs.sponsor_id as id,
    s.company_name as Name,
    bs.amount as amount
FROM eventsphere.concerts_events ce
JOIN eventsphere.budget_sponsorships bs ON ce.event_id = bs.event_id
JOIN eventsphere.sponsorships_partners s ON bs.sponsor_id = s.sponsor_id

UNION ALL

SELECT
	ce.event_id,
    ce.event_name,
    ce.date_event,
    ce.concert_status,
    'Venue' as Entity,
    bv.venue_id as id,
    v.venue_name as Name,
    (bv.amount*-1) as amount
FROM eventsphere.concerts_events ce
JOIN eventsphere.budget_venues bv ON ce.event_id = bv.event_id
JOIN eventsphere.venues v ON bv.venue_id = v.venue_id

ORDER BY event_id ASC;
#-------------------------------
#1.2. Visualize the CTE
#		See the result
SELECT * FROM budget;

#-------------------------------
#1.3. Profit table per event
#	Determine whether each event was profitable by summing its revenue and costs, and perform to classification methods
#(Quartile and Relative_Profit based on the general average)

CREATE VIEW event_profit AS 
SELECT
	event_id,
    event_name,
    date_event,
    SUM(amount) as Profit
FROM budget
WHERE concert_status = 'Completed'
GROUP BY event_id, event_name, date_event
ORDER BY Profit DESC;

SELECT * FROM event_profit;

WITH avg_profit AS (
    SELECT AVG(Profit) AS avg_profit FROM event_profit
)
SELECT
    e.event_id,
    e.event_name,
    e.date_event,
    e.Profit,
    NTILE(4) OVER (ORDER BY e.Profit) AS Quartiles,
    e.Profit/a.avg_profit AS Relative_Profit,
    CASE
		WHEN e.Profit/a.avg_profit >= 3 THEN 'HIGHLY PROFITABLE'
        WHEN e.Profit/a.avg_profit >= 1.5 AND e.Profit/a.avg_profit < 3 THEN 'PROFITABLE'
        WHEN e.Profit/a.avg_profit >= 0 AND e.Profit/a.avg_profit < 1.5 THEN 'VIABLE'
        ELSE 'UNPROFITABLE'
    END as Relative_Profit_Class
FROM event_profit e
CROSS JOIN avg_profit a
ORDER BY e.Profit DESC;


    