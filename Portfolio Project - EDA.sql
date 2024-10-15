SELECT MAX(total_laid_off) as max_total_laidoff,
   MAX(percentage_laid_off) as max_percentage_laid_off
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE CAST(percentage_laid_off AS FLOAT) = 1
ORDER BY funds_raised_millions DESC NULLS lAST;

-- Companies with the most Total Layoffs
SELECT company,sum(total_laid_off)
from layoffs_staging
GROUP BY company
ORDER BY 2 DESC NULLS LAST;

-- Locations with the most Total Layoffs
SELECT location , sum(total_laid_off)
from layoffs_staging
GROUP BY location
ORDER BY 2 DESC NULLS LAST;

-- Industries with the most Total Layoffs
SELECT industry,sum(total_laid_off)
from layoffs_staging
GROUP BY industry
ORDER BY 2 DESC NULLS LAST;

--stages with most layoffs
SELECT stage,sum(total_laid_off)
from layoffs_staging
GROUP BY stage
ORDER BY 2 DESC NULLS LAST;

-- date with the most Total Layoffs
SELECT "date",SUM(total_laid_off)
FROM layoffs_staging
GROUP BY "date"
ORDER BY 1 DESC NULLS LAST;

--Date with the most layoffs
SELECT "date",SUM(total_laid_off)
FROM layoffs_staging
GROUP BY "date"
ORDER BY 1 DESC NULLS LAST;

--year with the most layoffs
SELECT DATE_PART('year',"date"),SUM(total_laid_off)
from layoffs_staging
GROUP BY DATE_PART('year',"date")
ORDER BY 1 DESC NULLS LAST;

  or

  SELECT SUBSTRING(CAST(date AS TEXT), 1,4) as year,sum(total_laid_off)
  from layoffs_staging
  GROUP BY YEAR
  order by 1 desc NULLS last;



--rolling total layoff based on months
SELECT DATE_PART('month',"date") as MONTH
,SUM(total_laid_off)
from layoffs_staging
GROUP BY MONTH
ORDER BY 2 DESC NULLS LAST;

  or

  SELECT SUBSTRING(CAST(date as text),6,2) AS MONTH,
  SUM(total_laid_off)
  from layoffs_staging
  GROUP BY MONTH
  order by 2 DESC NULLS LAST;

--rolling total layoff based on months and years
SELECT SUBSTRING(CAST(date AS TEXT), 1, 7) AS MONTH, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY MONTH
ORDER BY 1 ASC;


--rolling total layoff based on months IN CTE approach
WITH ROlling_total AS
(
SELECT SUBSTRING(CAST(date AS TEXT), 1, 7) AS MONTH, 
       SUM(total_laid_off) AS total_off
FROM layoffs_staging
GROUP BY MONTH
ORDER BY 1 ASC
)
SELECT MONTH,total_off, SUM(total_off) OVER(order BY MONTH) AS rolling_total
FROM rolling_total;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. It's a little more difficult.

SELECT company,
       Date_part('YEAR', "date") AS year,
       SUM(total_laid_off)
FROM   layoffs_staging
GROUP  BY company,
          year
ORDER  BY 3 DESC nulls last; 

WITH company_year AS (
  SELECT company, 
         DATE_PART('YEAR', "date") AS years,  -- Extract year
         SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging
  GROUP BY company, DATE_PART('YEAR', "date")
),
company_year_rank AS (
  SELECT company, 
         years, 
         total_laid_off, 
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking  -- Rank based on total layoffs
  FROM company_year
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5  -- Get top 5 rankings
  AND years IS NOT NULL
    -- Make sure total_laid_off is valid
ORDER BY years ASC, ranking ASC;  











select *  from layoffs_staging ;
