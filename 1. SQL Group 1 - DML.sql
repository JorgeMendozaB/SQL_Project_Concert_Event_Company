#Insert into the table
INSERT INTO Genres (genre_id, genre_name) 
VALUES
	(1, 'Alternative'),
	(2, 'Blues'),
	(3, 'Classical'),
	(4, 'Country'),
	(5, 'Dance');



UPDATE eventsphere.Artists 
SET 
    instagram_followers = instagram_followers + CASE
        WHEN artist_name = 'Kendrick Lamar' THEN 700000
        WHEN artist_name = 'Drake' THEN 500000
    END
WHERE
    artist_name IN ('Kendrick Lamar' , 'Drake');


UPDATE eventsphere.Artists 
SET 
    spotify_monthly_listeners = spotify_monthly_listeners + CASE
        WHEN artist_name = 'Kendrick Lamar' THEN 500000
        WHEN artist_name = 'Drake' THEN 300000
    END
WHERE
    artist_name IN ('Kendrick Lamar' , 'Drake');



DELETE FROM eventsphere.Budget_Venues 
WHERE
    payment_status = 'Completed'
    AND amount < 200000;


    
    

	
    
    
    