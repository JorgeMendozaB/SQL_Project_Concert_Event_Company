#The marketing department wants to know if there is a relation between some variables and the total amount of tickets sales.
#These are the following variables: early_bird_days, regular_sales_days, line up average monthly listeners

SELECT
	ce.event_id,
    ce.event_name,
    ce.date_event,
    COUNT(ba.event_id) as Num_artists,
	datediff(ce.date_regular_sales, ce.date_early_bird) as early_bird_days,
    datediff(ce.date_event, ce.date_regular_sales) as regular_sales_days,
    ROUND(AVG(a.spotify_monthly_listeners),0) as lineup_avg_Spotify_ml,
	bt.amount
FROM concerts_events ce
JOIN budget_ticketing bt ON ce.event_id = bt.event_id
JOIN budget_artists ba ON ce.event_id = ba.event_id
JOIN artists a ON ba.artist_id = a.artist_id
WHERE ce.concert_status = 'Completed'
GROUP BY ce.event_id, ce.event_name, bt.amount, ce.date_event;
