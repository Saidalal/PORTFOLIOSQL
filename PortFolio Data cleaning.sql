DROP table layoffs;
CREATE TABLE layoffs (
    "company" TEXT,
    "location" TEXT,44
    "industry" TEXT,
    "total_laid_off" INT,
    "percentage_laid_off" TEXT,
    "date" TEXT,
    "stage" TEXT,
    "country" TEXT,
    "funds_raised_millions" INT

);

select * from layoffs;

ALTER TABLE LAYOFFS
ALTER funds_raised_millions TYPE NUMERIC;

COPY layoffs(company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions)
FROM 'D:/sqlpractice/PORTFOLIO/layoffs.csv'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

select * from layoffs;

---copyone table to another

DROP TABLE layoffs_staging;

create table layoffs_staging
(LIKE layoffs INCLUDING ALL);

insert into layoffs_staging
SELECT * FROM layoffs;

-- Check the content of layoffs_staging
SELECT * FROM layoffs_staging;

SELECT  * ,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,
percentage_laid_off ,"date") AS row_num
FROM layoffs_staging;


-- Check for duplicates
with duplicate_cte AS (
	SELECT * ,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,"date", stage,country, 
			funds_raised_millions) AS row_num
	FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
where row_num > 1;

WITH DELETE_CTE AS (
    SELECT ctid, 
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, "date", stage, country, funds_raised_millions
               ORDER BY ctid) AS row_num
    FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE ctid IN (
    SELECT ctid FROM DELETE_CTE WHERE row_num > 1
);


-----standardizing data

SELECT company,TRIM(company) 
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);

SELECT DISTINCT INDUSTRY
FROM layoffs_staging
ORDER BY 1;

select *
from layoffs_staging
where industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
where industry LIKE 'Crypto%';

SELECT DISTINCT INDUSTRY
FROM layoffs_staging;

SELECT DISTINCT COUNTRY
FROM layoffs_staging
ORDER BY 1;

SELECT DISTINCT COUNTRY , TRIM(TRAILING '.' from country)
from layoffs_staging
order by 1;

UPDATE layoffs_staging
SET COUNTRY = TRIM(TRAILING '.' from country)
WHERE COUNTRY LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;

SELECT 
    "date",
    TO_DATE("date"::text, 'YYYY-MM-DD') AS converted_date
FROM 
    layoffs_staging;



UPDATE layoffs_staging
set "date" = TO_DATE("date"::text, 'YYYY-MM-DD');

ALTER TABLE layoffs_staging
ALTER COLUMN "date" TYPE DATE
USING TO_DATE("date"::text, 'YYYY-MM-DD');


select *
FROM layoffs_staging
order by 1;

ALTER table layoffs_staging
DROP  column row_num  ;

SELECT  * ,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,
percentage_laid_off ,"date") AS row_num
FROM layoffs_staging;

-- 4. remove any columns and rows we need to

select *
from layoffs_staging
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
from layoffs_staging
WHERE industry IS NULL
or industry = ''
order by 1;

select distinct *
from
layoffs_staging
order by 1;