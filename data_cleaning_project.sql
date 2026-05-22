-- Data Cleaning----------------------------

-- 1. Remove Duplicates
-- 2. Standardise the Data
-- 3. Null Values or blank values
-- 4. Remove Any uncessary Columns
-- -----------------------------------------

-- 1. Remove Duplicates

# First let's check for duplicates


CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT*
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `data`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1; -- this query output will show the duplicates

#looking at casper to confirm these are duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';


-- creating the staging table where we can delete duplicates instead of deleting raw data
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- it looks like these are all legitimate entries and shouldn't be deleted. Will examine look at every single row to be accurate

-- these are the real duplicates 
 
INSERT INTO layoffs_staging2 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT*
FROM layoffs_staging2;

-- 2. Standardising data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company); #trim removes the white space

-- looking at industry it looks like we have some null and empty rows, let's take a look at these

SELECT DISTINCT industry
from layoffs_staging2
ORDER BY 1; -- > may see some null, some values in the column that might mean the same thing i.e crypto and crypto currency

SELECT*
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; -- now these are all just "crypto", not cyrpto and cyrpto currency

select distinct country
from layoffs_staging2
WHERE country like 'United States%' ;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

select DISTINCT country
from layoffs_staging2;


# changing the date column from text to date column
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');# this '%m/%d/%Y' is the correct format for transorming the date column

SELECT `date`
FROM layoffs_staging2; # formatting worked but it is still defined as text in mysql 

#offically changing the data type of date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

#working with null and blank values

#first look at nulls in total_laid_off

SELECT*
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#SET THE  BLANKS TO NULLS
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company  LIKE 'Bally%';

-- now we need to populate those nulls if possible

SELECT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

#getting rid of the NULL  percentage and total layoffs rows
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT*
FROM layoffs_staging2;

-- 4. DROPPING A COLUMN
ALTER TABLE  layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM world_layoffs.layoffs_staging2;

