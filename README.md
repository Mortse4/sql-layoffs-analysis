# SQL-layoffs-analysis
This project analyses global layoffs data using SQL. The workflow included cleaning raw datasets, standardising inconsistent values, handling nulls and duplicates, and performing exploratory data analysis (EDA) to identify trends and patterns in layoffs across industries, countries, and company stages.


🗂️ Dataset

The dataset contains information on company layoffs including:

Company
Location
Industry
Total laid off
Percentage laid off
Date
Company stage
Country
Funds raised
🧹 Data Cleaning Process

The raw dataset was cleaned using SQL in MySQL through a structured staging approach:

Removed duplicate records using window functions
Standardised inconsistent values across categorical fields
Handled missing values in key columns
Converted and standardised date formats
Removed irrelevant or incomplete rows

All transformations were performed using staging tables to ensure data integrity during processing.

🔍 Exploratory Data Analysis (EDA)

SQL was used to analyse and uncover patterns in the cleaned dataset:

Companies with the highest layoffs
Layoffs by industry and country
Trends in layoffs over time
Companies with 100% workforce reductions
Impact of funding on layoffs
🛠️ Tools Used
MySQL
SQL (CTEs, window functions, joins, aggregations)
Data cleaning & transformation techniques


🚀 Key Takeaways
Technology sector experienced the highest volume of layoffs - possibly due to time period (Covid-19 Pandemic etc)
Significant layoffs occurred across both startups and post-IPO companies
Clear regional differences in layoff trends were observed (Top countires like USA)
