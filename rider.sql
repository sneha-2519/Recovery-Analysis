create database mtaRaider;

USE mtaRaider;

CREATE TABLE mtaraider.raider(
    Date_MTA DATE,
    Subways_Total_Estimated_Ridership INT,
    Subways_Percentage_of_Pre_Pandemic INT,
    Buses_Total_Estimated_Ridership INT,
    Buses_Percentage_of_Pre_Pandemic INT,
    LIRR_Total_Estimated_Ridership INT,
    LIRR_Percentage_of_Pre_Pandemic INT,
    MetroNorth_Total_Estimated_Ridership INT,
    MetroNorth_Percentage_of_Pre_Pandemic INT,
    AccessARide_Total_Scheduled_Trips INT,
    AccessARide_Percentage_of_Pre_Pandemic INT,
    Bridges_Tunnels_Total_Traffic INT,
    Bridges_Tunnels_Percentage_of_Pre_Pandemic INT,
    Staten_Island_Railway_Total_Estimated_Ridership INT,
    Staten_Island_Railway_Percentage_of_Pre_Pandemic INT

	);
    
    select * from mta_daily_ridership;
    
    --- 1) Find the highest ridership day for subways
    
    SELECT Date_MTA , Subways_Total_Estimated_Ridership As  Highest_Ridership 
    FROM mta_daily_ridership
    ORDER BY Subways_Total_Estimated_Ridership DESC
    LIMIT 1;
    
    --- 2) Average bus ridership percentage since the pandemic
    
    SELECT avg(Buses_Percentage_of_Pre_Pandemic) AS Avg_Bus_Per
    FROM mta_daily_ridership;
    
    --- 3) Identify days when Metro-North ridership exceeded 100,000
    
    SELECT  Date_MTA, MetroNorth_Total_Estimated_Ridership
    FROM mta_daily_ridership
    WHERE MetroNorth_Total_Estimated_Ridership > 100000;
    
    --- 4) Get the total traffic for bridges and tunnels over the entire dataset
    
    SELECT SUM(Bridges_Tunnels_Total_Traffic) AS Total_traffic 
	FROM mta_daily_ridership;
      
    --- 5) Find the date with the lowest 5 recorde of percentage of pre-pandemic ridership for Access-A-Ride
    
    SELECT Date_MTA, AccessARide_Percentage_of_Pre_Pandemic
    FROM mta_daily_ridership
    ORDER BY AccessARide_Percentage_of_Pre_Pandemic DESC
    LIMIT 5;
    
    --- 6) Calculate weekly average ridership rather than analyzing fluctuations on a daily basis
    
    SELECT year(Date_MTA) as year, 
		Week(Date_MTA) As week, 
        AVG(Subways_Total_Estimated_Ridership) As Avg_Subway_Ridership
	FROM mta_daily_ridership
    GROUP BY year, week;
	
    
    --- 7) Monitor railway ridership recovery trends post-pandemic by comparing percentages
    
    SELECT 
  Date_MTA,
  (Staten_Island_Railway_Percentage_of_Pre_Pandemic - LAG(Staten_Island_Railway_Percentage_of_Pre_Pandemic) 
  OVER (ORDER BY Date_MTA)) AS Daily_Change
FROM mta_daily_ridership;

--- 8) Total Ridership by Year for Subways, Buses, LIRR, and Metro-North

SELECT 
    YEAR(Date_MTA) AS Year,
    SUM(Subways_Total_Estimated_Ridership) AS Total_Subway_Ridership,
    SUM(Buses_Total_Estimated_Ridership) AS Total_Bus_Ridership,
    SUM(LIRR_Total_Estimated_Ridership) AS Total_LIRR_Ridership,
    SUM(MetroNorth_Total_Estimated_Ridership) AS Total_MetroNorth_Ridership
FROM 
    mta_daily_ridership
GROUP BY 
    YEAR(Date_MTA)
ORDER BY 
    Year;
    
--- 9) Top 3 Highest Ridership Days per Year

SELECT 
    Date_MTA,
    YEAR(Date_MTA) AS Year,
    Subways_Total_Estimated_Ridership
FROM 
    mta_daily_ridership AS outer_table
WHERE 
    (SELECT COUNT(DISTINCT Subways_Total_Estimated_Ridership)
     FROM mta_daily_ridership AS inner_table
     WHERE YEAR(inner_table.Date_MTA) = YEAR(outer_table.Date_MTA)
       AND inner_table.Subways_Total_Estimated_Ridership >= outer_table.Subways_Total_Estimated_Ridership) <= 3
ORDER BY 
    Year DESC , Subways_Total_Estimated_Ridership ASC;
    
    
--- 10) Year-wise Percentage of Pre-Pandemic Ridership

SELECT 
    Date_MTA ,
    AVG(Subways_Percentage_of_Pre_Pandemic) AS Subway_Percent_Pre_Pandemic,
    AVG(Buses_Percentage_of_Pre_Pandemic) AS Bus_Percent_Pre_Pandemic,
    AVG(LIRR_Percentage_of_Pre_Pandemic) AS LIRR_Percent_Pre_Pandemic,
    AVG(MetroNorth_Percentage_of_Pre_Pandemic) AS MetroNorth_Percent_Pre_Pandemic
FROM 
    mta_daily_ridership
GROUP BY 
    Date_MTA 
ORDER BY 
        Date_MTA ;





    
    
    
    
    

