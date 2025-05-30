-- Data Cleaning 
-- It best practice not to work from the original data I would create a duplicate table

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any Columns or rows 

SELECT COUNT(*)
FROM lAYoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;


SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';






-- Here I created another duplicate table name it layoffs_staging2 because I cannot delete from the original cte in mysql
-- How I created another table is by right clicking on the left panel layoffs_staging and copy to clipboard and pasting on the query page listed under where it said created a table layoffs_stg2

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


-- TRUNCATE TABLE layoffs_staging2;

SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


 DELETE
 FROM layoffs_staging2
 WHERE row_num > 1;


 SELECT *
 FROM layoffs_staging2
 WHERE row_num > 1;


 SELECT *
 FROM layoffs_staging2;



-- Standardizing Data 
-- use TRIM to delete the space infront and behind the company names

 SELECT company,TRIM(company)
 FROM layoffs_staging2;

 UPDATE layoffs_staging2
 SET company = TRIM(company);
 
 ---------

 SELECT DISTINCT industry
 FROM layoffs_staging2
 ORDER BY 1;

 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%';
 
 UPDATE layoffs_staging2
 SET industry = 'Crypto'
 WHERE industry LIKE 'Crypto%';
 
 SELECT DISTINCT industry
 FROM layoffs_staging2;
 
 -------
 -- no issue here 
 SELECT DISTINCT location
 FROM layoffs_staging2
 ORDER BY 1;
 
 -- Getting rid of the . near United States 
 SELECT DISTINCT country
 FROM layoffs_staging2
 ORDER BY 1;
 
 SELECT *
 FROM layoffs_staging2
 WHERE country LIKE 'United States%'
 ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
 FROM layoffs_staging2
 ORDER BY 1;
 
 UPDATE layoffs_staging2
 SET country = TRIM(TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';
 
 ---------
 -- Date is in text if we want to use date column like with a time series we need to change it formatting 
 SELECT `date`,
 STR_TO_DATE(`date`, '%m/%d/%Y')
 FROM layoffs_staging2;
 
 UPDATE layoffs_staging2
 SET `date` =  STR_TO_DATE(`date`, '%m/%d/%Y');
 
 SELECT `date`
 FROM layoffs_staging2;

-- Here we alter the table to change it from text to DATE

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



--------
-- veiwing the data
SELECT *
FROM layoffs_staging2;

-- veiwing the null or blank
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';


SELECT *
FROM layoffs_staging2 
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


-- This join table look at both table join
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON T1.company = t2.company
      AND t1.location = t2.location
 WHERE (t1.industry IS NULL OR t1.industry = '') 
 AND t2.industry IS NOT NULL;


-- This join table looks that the industry column side by side
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
      ON T1.company = t2.company
      AND t1.location = t2.location
 WHERE (t1.industry IS NULL OR t1.industry = '') 
 AND t2.industry IS NOT NULL;
 
 
 UPDATE layoffs_staging2 t1
 JOIN layoffs_staging2 t2
      ON T1.company = t2.company
SET  t1.industry = t2.industry   
 WHERE t1.industry IS NULL 
 AND t2.industry IS NOT NULL;   
 
 
--- Bally cannot be populated because there is not another industry that has the information to populated by
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


--- Deleting rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;


--- Deleting column
SELECT *
FROM layoffs_staging2;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
