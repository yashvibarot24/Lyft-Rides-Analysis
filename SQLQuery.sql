-- ## Optimizing Ride Demand and Operational Efficiency for Lyft: A Data-Driven Analysis
-- ## Project by YASHVI BAROTE

CREATE DATABASE Lyftridesdatabase ;
USE Lyftridesdatabase;

CREATE TABLE LyftRidesdata (
    instant INT,
    date DATE,
    season INT,
    year INT,
    month INT,
    hour INT,
    holiday BIT,
    weekday INT,
    workingday BIT,
    weathersit INT,
    temperature FLOAT,
    atemp FLOAT,
    humidity FLOAT,
    windspeed FLOAT,
    casual INT,
    registered INT,
    count INT
);


EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;


BULK INSERT LyftRidesdata
FROM 'C:\Projects\uber vs Lyft\lyft dataset.csv'
WITH (
    FIRSTROW = 2,            -- Skip the header row
    FIELDTERMINATOR = ',',   -- Columns are separated by commas
    ROWTERMINATOR = '\n',    -- Rows are separated by newlines
    TABLOCK                 -- Optimizes performance for large datasets
);


-- # Total Rides by User Type

SELECT 
    SUM(casual) AS Total_Casual_Rides,
    SUM(registered) AS Total_Registered_Rides,
    SUM(count) AS Total_Rides
FROM LyftRidesdata;

-- # Rides Distribution by Season

SELECT 
    season AS Season,
    SUM(count) AS Total_Rides,
    ROUND((SUM(count) * 100.0) / (SELECT SUM(count) FROM LyftRidesdata), 2) AS Percentage_Of_Total
FROM LyftRidesdata
GROUP BY season
ORDER BY Total_Rides DESC;

-- # Peak Ride Hours

SELECT 
    hour AS Hour,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY hour
ORDER BY Average_Rides DESC;


-- # Weather Impact on Ride Demand

SELECT 
    weathersit AS Weather_Condition,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY weathersit
ORDER BY Average_Rides DESC;

-- # Weekly Trends in Ride Demand

SELECT 
    weekday AS Weekday,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY weekday
ORDER BY weekday;

-- # Top 5 Days with Highest Rides

SELECT TOP 5
    date AS Date,
    SUM(count) AS Total_Rides
FROM LyftRidesdata
GROUP BY date
ORDER BY Total_Rides DESC;

-- # Correlation Between Temperature and Rides

SELECT 
    temperature AS Temperature,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY temperature
ORDER BY Temperature ASC;

-- # Holiday vs. Non-Holiday Rides

SELECT 
    holiday AS Is_Holiday,
    SUM(count) AS Total_Rides,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY holiday;

-- # Working Day vs. Non-Working Day Rides

SELECT 
    workingday AS Is_Working_Day,
    SUM(count) AS Total_Rides,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY workingday;

-- # Seasonal and Hourly Ride Heatmap Data

SELECT 
    season AS Season,
    hour AS Hour,
    AVG(count) AS Average_Rides
FROM LyftRidesdata
GROUP BY season, hour
ORDER BY Season, Hour;