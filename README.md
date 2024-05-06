# Google Data Analytics Professional Certificate
# Capstone Project - BellaBeat CaseStudy
## Introduction 
This is a case study conducted within the Google Data Analytics Professional Certificate using **SQL and Tableau** to study how a wellness company can gain insights through analyzing device fitness data to unlock new growth opportunities. 
<p align="left">
  <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/70cda19c-6626-45e5-aaee-aba2ae9c1d24" width="300" height="100">
</p>
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
- Checked DataTypes: In all 3 CSV files, the date column activityDate, SleepDay, and Date are put to Text type and not Date.
### Data Transformations
- Drop duplicates in sleepday_merged.
- Change DataTypes for each of the Date columns. This is an example for the SleepDay column in sleepday_merged.
- Drop unnecessary columns: Some columns in weightLoginfo_merged we will not be using due a large number of missing values in the *Fat* column or data irrelevant for our analysis such as *LogId*. Thus, we will drop these columns.
- Add a *DayOfWeek* column that indicates activity corresponding to which day of the week and a *DayType* column that indicates activity corresponding to weekends/weekdays. We will use these columns in our analysis later on.
- Add a *BMIType* column that indicates whether the individual is 'Normal Weight', 'Obese', or 'Overweight'.
## 4. Analyze 
### Users' Activity Insights 
- Users engage in physical activity for 18.67% of the day (3.79 hours/day), with the remaining 81.33% spent in sedentary pursuits. The 18.67% is distributed as follows: *1.74%* VeryActive, *1.11%* FairlyActive, and *15.82%* LightlyActive.
  ![3](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/3001b973-ed9c-409b-9f44-c3ecb557330e)
  
  ![2](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/554cc200-6785-4f46-883e-b65a9d515b56)
  
- The average daily calorie burn is 2303.60, which is within the recommended range. It goes up slightly on weekends to *2317.0997* compared to *2294.8137* on weekdays.
  
  ![4](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/66ac0bc3-499e-4518-a9ab-666fa22b6481)

  ![5](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/c96b0579-6b2d-4dcc-95d9-970d851021a8)

- The number of calories burned is influenced by the intensity of the activity performed. The more intense the activity, the more calories are burned.
  
  <p align="center">
  <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/ee6dc1b5-a6d3-4fe0-aa0a-af756d3716dc" width="800" >
</p>

- While most users maintained a healthy daily step count of over 5000, only 7 out of 33 users (21%) successfully reached the milestone of averaging 10,000 steps per day.

   <p align="center">
  <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/dc4d426e-67bd-4732-b4f4-b97aa20b393c"  width="800"
  </p>
- Users are most active on Saturdays and Tuesdays, taking the most steps and covering the longest distances. However, their activity decreases on Sundays given it is their rest day.

   <p align="center">
  <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/44224a03-3327-4495-a1dc-665f1c25c710"  width="800"
  </p>
- Users who take more steps tend to burn more calories, as evidenced by a positive correlation coefficient of 0.5961. This suggests that for every 1% increase in step count, there is a corresponding increase of approximately 0.6% in calories burned.
    <p align="center">
  <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/95a45c43-0ef1-462f-9722-49e329d3dae2"  width="800"
  </p>

### Users' Sleep Insights 
- On average, users take about 42 minutes to fall asleep and usually sleep for around 7 hours. However, over 42% of them frequently sleep less than 7 hours a day, suggesting potential issues with sleep deficiency.
  
  ![8](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/fa992c06-3ae3-45a6-a999-671c7ae72a33)

  ![9](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/ff4da18d-7d57-42d8-8bb0-80f733f647d2)

  ![TillSleep](https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/1a6d5f9a-322f-417e-822d-e8970759c5bb)


- Users who spend more time being sedentary are likely to experience greater sleep deficiency as there is a negative correlation of -0.61 between SedentaryMinutes and TotalMinutesAsleep, suggesting that for every 1% increase in sedentary minutes, total sleep time decreases by 0.61%.
  <p align="center">
   <img src="https://github.com/maissaladjimi/Google_Data_Analytics_Certif/assets/94018321/e558b798-80a8-496c-a1d7-82184c8dc3c6" width="600"
   </p>
### Users' Weight Logging Insights 
- Unfortunately, although this type of data is important to our analysis, it only holds insights into 8 distinct users with 68 entries. Out of these individuals, 1 is obese, 4 are overweight, and 3 are Normal Weight.

## 5. Share
View the interactive dashboards on my [Tableau Profile](https://public.tableau.com/app/profile/maissa.lajimi/vizzes) 

### Users' Activity Insights 
![Tableau1](https://github.com/maissaladjimi/Google_Data_Analytics_Certifcate/assets/94018321/7986e9bc-df8d-4417-9f36-fb88efb7b293)

### Users' Sleep Insights  
![Tableau2](https://github.com/maissaladjimi/Google_Data_Analytics_Certifcate/assets/94018321/15b7d077-c0c1-43d5-8857-39d925edef83)

## 6. Act 
