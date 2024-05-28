-- view the entire table
SELECT * FROM abingdon.weather;

-- query the number of rainy days in each year
SELECT 
	EXTRACT(YEAR FROM date) AS year,
	COUNT(*) as rainy_days
FROM weather
WHERE precipitation > 0
GROUP BY year;

-- query the day with the highest rainfall
SELECT
	date AS rainiest_day,
    precipitation
FROM weather
WHERE precipitation = (
	SELECT
		MAX(precipitation)
	FROM weather);
            
-- query the day with the highest max temperature
SELECT
	date AS hottest_high,
    max_temp
FROM weather
WHERE max_temp = (
	SELECT 
		MAX(max_temp)
	FROM weather);
    
-- query the day with the lowest min temperature
SELECT
	date AS lowest_low,
    min_temp
FROM weather
WHERE min_temp = (
	SELECT 
		MIN(min_temp)
	FROM weather);
    
-- query the average rainfall per year
SELECT
	EXTRACT(YEAR FROM date) AS year,
    ROUND(AVG(precipitation), 3) AS avg_rainfall
FROM weather
GROUP BY year;

-- query the average temperature per year
SELECT
	EXTRACT(YEAR FROM date) AS year,
    ROUND(AVG(max_temp - min_temp / 2), 1) AS avg_temp
FROM weather
GROUP BY year;

-- query the average max and min temperatures per year
SELECT
	EXTRACT(YEAR FROM date) AS year,
    ROUND(AVG(min_temp), 1) AS avg_low,
    ROUND(AVG(max_temp), 1) AS avg_high
FROM weather
GROUP BY year;

-- query tomorrow's forecast based on the average rainfall and temps of each day of the year
WITH daily_average AS (
	SELECT 
		EXTRACT(MONTH FROM date) AS month,
		EXTRACT(DAY FROM date) AS day,
		ROUND(AVG(precipitation), 2) AS avg_rainfall,
        ROUND(AVG(max_temp), 1) AS avg_high,
        ROUND(AVG(min_temp), 1) AS avg_low
	FROM weather
	GROUP BY month, day
	ORDER BY month, day
)
SELECT * 
FROM daily_average
WHERE month = MONTH((CURDATE())) AND 
    day = DAY(DATE_ADD(CURDATE(), INTERVAL 1 DAY));