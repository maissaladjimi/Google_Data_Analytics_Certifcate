-- CHECK DUPLICATES -- 
SELECT Id, Date, WeightKg, WeightPounds, COUNT(*) AS count_duplicates FROM weightloginfo_merged GROUP BY Id, Date, WeightKg, WeightPounds HAVING COUNT(*) > 1;
SELECT Id, COUNT(*) AS count_duplicates FROM sleepday_merged GROUP BY Id, sleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed HAVING count(*) > 1 ; 
SELECT Id, COUNT(*) AS count_duplicates FROM dailyactivity_merged GROUP BY Id, activityDate, TotalSteps, TotalDistance, Calories HAVING count(*) > 1 ; 

-- CHECK DATATYPE -- 
DESCRIBE sleepday_merged ;
DESCRIBE dailyactivity_merged ; 
DESCRIBE weightloginfo_merged ; 

-- DROPPING DUPLICATES -- 
DELETE FROM sleepday_merged 
WHERE Id IN (SELECT Id FROM ( SELECT Id FROM bellabeat.sleepday_merged 
										GROUP BY Id, sleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed 
                                        HAVING COUNT(*) > 1 ) AS duplicates );

-- CHANGING DATATYPES -- 
UPDATE dailyactivity_merged SET activityDate = STR_TO_DATE(activityDate, '%m/%d/%Y');
ALTER TABLE dailyactivity_merged MODIFY COLUMN activityDate DATE;

UPDATE sleepday_merged SET SleepDay = DATE_FORMAT(STR_TO_DATE(SleepDay, '%m/%d/%Y %h:%i:%s %p'), '%m/%d/%Y') ;
UPDATE sleepday_merged SET SleepDay = STR_TO_DATE(SleepDay, '%m/%d/%Y');
ALTER TABLE sleepday_merged MODIFY COLUMN SleepDay DATE;

UPDATE weightloginfo_merged SET Date = DATE_FORMAT(STR_TO_DATE(Date, '%m/%d/%Y %h:%i:%s %p'), '%m/%d/%Y') ;
UPDATE weightloginfo_merged SET Date = STR_TO_DATE(Date, '%m/%d/%Y');
ALTER TABLE weightloginfo_merged MODIFY COLUMN Date DATE;

-- DROPPING UNNECESSARYY COLUMNS -- 
ALTER TABLE weightloginfo_merged DROP COLUMN Fat, DROP COLUMN LogId, DROP COLUMN IsManualReport;

-- DayOfWeek --
ALTER TABLE dailyactivity_merged
ADD COLUMN DayOfWeek VARCHAR(20);
UPDATE dailyactivity_merged
SET DayOfWeek = DAYNAME(activityDate);

-- DayType --
ALTER TABLE dailyactivity_merged
ADD COLUMN DayType VARCHAR(20);
UPDATE dailyactivity_merged SET DayType = CASE WHEN DAYNAME(activityDate) IN ('Friday', 'Saturday', 'Sunday') THEN 'Weekend'
											   ELSE 'Weekday' 
                                               END;

-- BMI -- 
ALTER TABLE weightloginfo_merged
ADD COLUMN BMIType VARCHAR(20);
UPDATE weightloginfo_merged SET BMIType = CASE  WHEN BMI < 18.5 THEN 'Underweight'  
												WHEN BMI > 30 THEN 'Obese'  
                                                WHEN BMI BETWEEN 25 and 30 THEN 'Overweight'  
                                                ELSE 'Normal weight' END;
-- ANALYSIS -- 

-- Users' Activity Insights -- 
SELECT  
    ROUND(AVG(da.VeryActiveMinutes)) AS VeryActive, 
    ROUND(AVG(da.FairlyActiveMinutes)) AS FairlyActive,
    ROUND(AVG(da.LightlyActiveMinutes)) AS LightlyActive,
    ROUND(AVG(da.SedentaryMinutes)) AS Sedentary 
FROM dailyactivity_merged AS da;

SELECT 
	ROUND((AVG(da.VeryActiveMinutes) / 60) / (AVG(da.VeryActiveMinutes) / 60 + AVG(da.FairlyActiveMinutes) / 60 + AVG(da.LightlyActiveMinutes) / 60 + AVG(da.SedentaryMinutes) / 60) * 100, 2) AS PercentageVeryActive,
	ROUND((AVG(da.FairlyActiveMinutes) / 60) / (AVG(da.VeryActiveMinutes) / 60 + AVG(da.FairlyActiveMinutes) / 60 + AVG(da.LightlyActiveMinutes) / 60 + AVG(da.SedentaryMinutes) / 60) * 100, 2) AS PercentageFairlyActive,
	ROUND((AVG(da.LightlyActiveMinutes) / 60) / (AVG(da.VeryActiveMinutes) / 60 + AVG(da.FairlyActiveMinutes) / 60 + AVG(da.LightlyActiveMinutes) / 60 + AVG(da.SedentaryMinutes) / 60) * 100, 2) AS PercentageLightlyActive,
	ROUND((AVG(da.SedentaryMinutes) / 60) / (AVG(da.VeryActiveMinutes) / 60 + AVG(da.FairlyActiveMinutes) / 60 + AVG(da.LightlyActiveMinutes) / 60 + AVG(da.SedentaryMinutes) / 60) * 100, 2) AS PercentageSedentary
FROM 
    dailyactivity_merged AS da;

 SELECT 
    ROUND((SUM(da.VeryActiveMinutes) + SUM(da.FairlyActiveMinutes) + SUM(da.LightlyActiveMinutes)) / (SUM(da.VeryActiveMinutes) + SUM(da.FairlyActiveMinutes) + SUM(da.LightlyActiveMinutes) + SUM(da.SedentaryMinutes)) * 100, 2) AS PercentageActive,
    ROUND((SUM(da.SedentaryMinutes)) / (SUM(da.VeryActiveMinutes) + SUM(da.FairlyActiveMinutes) + SUM(da.LightlyActiveMinutes) + SUM(da.SedentaryMinutes)) * 100, 2) AS PercentageSedentary
FROM 
    dailyactivity_merged AS da;

SELECT 
    ROUND((AVG(da.VeryActiveMinutes) + AVG(da.FairlyActiveMinutes) + AVG(da.LightlyActiveMinutes))/60  , 2) AS AverageHoursActive,
    ROUND((AVG(da.SedentaryMinutes)) / 60 , 2) AS AverageHoursSedentary
FROM 
    dailyactivity_merged AS da;

SELECT AVG(da.calories) AS Average_daily_calories FROM  dailyactivity_merged AS da;
SELECT da.DayType, AVG(da.calories) AS Average_calories FROM  dailyactivity_merged AS da GROUP BY da.DayType 
ORDER BY Average_calories DESC;

SELECT da.DayOfWeek, AVG(da.TotalDistance), AVG(da.TotalSteps) FROM dailyactivity_merged AS da 
GROUP BY da.DayOfWeek ORDER BY AVG(da.TotalDistance) DESC ;

-- Users' Sleep Insights -- 
SELECT
 (AVG(sm.TotalTimeInBed)/ 60)  AS TotalHoursInBed, 
 (AVG(sm.TotalMinutesAsleep) /60 ) AS TotalHoursAsleep,
 (AVG(sm.TotalTimeInBed) - AVG(sm.TotalMinutesAsleep)) AS average_minutes_till_sleep 
FROM sleepday_merged AS sm ;

SELECT 
    COUNT(*) AS SleepLessThan7Hours,
    (COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT Id) FROM sleepday_merged)) AS Percentage_SleepLessThan7Hours
FROM (
    SELECT sm.Id
    FROM sleepday_merged AS sm
    GROUP BY sm.Id
    HAVING AVG(sm.TotalTimeInBed) / 60 < 7
) AS SleepLessThan7Hours;