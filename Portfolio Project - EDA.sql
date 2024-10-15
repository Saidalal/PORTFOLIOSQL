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

SELECT stage,sum(total_laid_off)
from layoffs_staging
GROUP BY stage
ORDER BY 2 DESC NULLS LAST;

--rolling total layoff based on months
SELECT DATE_PART('month',"date") as 'MONTH',SUM(total_laid_off)
from layoffs_staging
GROUP BY MONTH
ORDER BY 2 ASC NULLS LAST;



select *  from layoffs_staging ;