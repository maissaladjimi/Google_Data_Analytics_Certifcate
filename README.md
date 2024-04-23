# Google Data Analytics Professional Certificate
# Capstone Project - BellaBeat CaseStudy
## Introduction 
This is a case study conducted within the Google Data Analytics Professional Certificate using **SQL and Tableau** to study how a wellness company can gain insights through analyzing device fitness data to unlock new growth opportunities.

![Bellabeat_logo](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/70cda19c-6626-45e5-aaee-aba2ae9c1d24)

In this case study, we will perform data analysis for Bellabeat, a high-tech manufacturer of health-focused products for women. We will analyze smart device data to gain insight into how consumers are using their smart devices. We will follow the steps of the data analysis process: **Ask, Prepare, Process, Analyze, Share, and Act**.

## 1. Ask 
### Business Task 
Analyze smart device usage data to gain insights into how customers use non-BellaBeat smart devices and provide recommendations on how these trends can help improve BellaBeat's marketing strategy.
### Key Stakeholders 
- *Urška Sršen*: Bellabeat’s co-founder and Chief Creative Officer.
- *Sando Mur*: Mathematician and Bellabeat’s co-founder.
- *Bellabeat marketing analytics team*: A team of data analysts responsible for collecting, analyzing, and reporting data that helps guide Bellabeat’s marketing strategy.
## 2. Prepare 
### Data Description 
Fitbit Fitness Tracker Data is a dataset that contains personal fitness trackers from 30 Fitbit users. It includes information about daily activity, steps, sleep, weight, heart rate, etc.
### Data Sources 
Data is made available through Modius in [Kaggle](https://www.kaggle.com/datasets/arashnic/fitbit?select=mturkfitbit_export_4.12.16-5.12.16) with a CCO Public Domain License.
### Data Quality Checks (The ROCCC Method)
- Reliable? The data is not reliable since the sample selected holds records of only 30 individuals not accurately representing the overall population
- Original? The data is not original as it is not provided by FitBit.
- Comprehensive? The data is not comprehensive as it is missing some important information such as gender and age.
- Current? The data is not current, collected in 2016.
- Cited? Yes.

## 3. Process 
### Tools Used 
I used **SQL** for cleaning, formatting, and transforming the data and **Tableau** for visualization. I first opened the data in **Excel** to view and understand its structure.
### Checking Data 
I used MySQL Workbench to upload the CSV files. I decided to only upload *dailyactivity_merged*, *sleepday_merged*, and *weightLoginfo_merged* and drop the rest. 
- Checked Missing Values. I noticed a few null values in the datasets, which I decided to keep as it is relevant to our analysis. 
- Checked Duplicated Data: Only the sleepday_merged has 3 duplicate records. This is an example code for sleepday_merged.
 ```sql
   SELECT Id, COUNT(*) AS count_duplicates FROM sleepday_merged
   GROUP BY Id, sleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed HAVING count(*) > 1 ; 
 ```
- Checked DataTypes: In all 3 CSV files, the date column activityDate, SleepDay, and Date are put to Text type and not Date.
```sql
  DESCRIBE dailyactivity_merged ;
  DESCRIBE sleepday_merged ;
  DESCRIBE weightloginfo_merged ; 
```
### Data Transformations
- Drop duplicates in sleepday_merged.
```sql
  DELETE FROM sleepday_merged
  WHERE Id IN (SELECT Id
               FROM ( SELECT Id
                      FROM sleepday_merged
                      GROUP BY Id, sleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
                      HAVING COUNT(*) > 1 ) AS duplicates
                    );
```
- Change DataTypes for each of the Date columns. This is an example for the SleepDay column in sleepday_merged.
```sql
  UPDATE sleepday_merged SET SleepDay = DATE_FORMAT(STR_TO_DATE(SleepDay, '%m/%d/%Y %h:%i:%s %p'), '%m/%d/%Y') ;
  UPDATE sleepday_merged SET SleepDay = STR_TO_DATE(SleepDay, '%m/%d/%Y');
  ALTER TABLE sleepday_merged MODIFY COLUMN SleepDay DATE;
```
- Drop unnecessary columns: Some columns in weightLoginfo_merged we will not be using due a large number of missing values in the *Fat* column or data irrelevant for our analysis such as *LogId*. Thus, we will drop these columns.
```sql
  ALTER TABLE weightloginfo_merged DROP COLUMN Fat, DROP COLUMN LogId, DROP COLUMN IsManualReport
```
- Add a *DayOfWeek* column that indicates activity corresponding to which day of the week and a *DayType* column that indicates activity corresponding to weekends/weekdays. We will use these columns in our analysis later on.
```sql
  ALTER TABLE dailyactivity_merged
  ADD COLUMN DayOfWeek VARCHAR(20);
  --
  UPDATE dailyactivity_merged
  SET DayOfWeek = DAYNAME(activityDate);
```

```sql
  ALTER TABLE dailyactivity_merged
  ADD COLUMN DayType VARCHAR(20);
  --
  UPDATE dailyactivity_merged
  SET DayType = CASE
                  WHEN DAYNAME(activityDate) IN ('Friday', 'Saturday', 'Sunday') THEN 'Weekend'
                  ELSE 'Weekday'
                END;
```


## 4. Analyze 

  
