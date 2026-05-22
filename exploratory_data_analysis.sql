-- Exploratory Data Analysis

-- In this project I explored the data and was finding trends or patterns or anything interesting like outliers


SELECT *
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT  MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * #companies that had 100% lay offs
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;
-- it looks like mostly startups who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT  company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- see the total layoffs in industries: looks like retial took a major hit, possibly due to covid as this data is during and post 2020
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- see the total layoffs in countries: 
SELECT country, SUM(total_laid_off) as sum_total_layoff
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`) as year , SUM(total_laid_off) as total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- ----------------------------------------------------------------

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- -----------------------------------------------------------------
# rolling total of layoffs

SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now used as a CTE to query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
