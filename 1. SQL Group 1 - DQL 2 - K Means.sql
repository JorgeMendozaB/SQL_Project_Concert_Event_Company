#The Logistics and Marketing departments are seeking to identify the most optimal venues
#in terms of ticket sales potential, prior event experience, and cost efficiency.
#This analysis aims to determine classification methods for venues based on three critical variables: attendance capacity, total number of events hosted, and average venue cost.
SELECT
    v.venue_name,
    p.province_name,
    v.attendance_capacity,
    COUNT(ce.event_id) AS total_events,
    ROUND(AVG(bv.amount),2) AS avg_venue_cost
FROM
    venues v
JOIN 
    cities c ON v.city_id = c.city_id
JOIN 
    provinces p ON c.province_id = p.province_id
JOIN 
    budget_venues bv ON v.venue_id = bv.venue_id
JOIN 
    concerts_events ce ON bv.event_id = ce.event_id
WHERE ce.concert_status = 'Completed'
GROUP BY 
    v.venue_name, p.province_name, v.attendance_capacity
ORDER BY avg_venue_cost DESC;

