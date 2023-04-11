-- CREATE DATABASE covid_db;

use covid_db;

select Count(*) from covid_deaths;
SELECT * FROM covid_deaths;


-- EDA
WITH cte AS(
SELECT location, 
ROW_NUMBER() OVER(PARTITION BY location ORDER BY date) AS rn_date,
ROW_NUMBER() OVER(PARTITION BY location ORDER BY total_cases, date) AS rn_cases,
ROW_NUMBER() OVER(PARTITION BY location ORDER BY total_deaths, date) AS rn_deaths
FROM covid_deaths)

SELECT location FROM cte WHERE rn_date != rn_cases
OR rn_date <> rn_deaths;
 


-- country cases table
SELECT continent, location AS country, MAX(total_cases) AS total_cases FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY country;




-- country deaths table
SELECT continent, location AS country, MAX(total_deaths) AS total_deaths FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY country;



-- fatality rate table
SELECT continent, location AS country, MAX(population) AS population, 
MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths,
MAX(total_cases)/MAX(population) * 100 AS percent_cases, 
MAX(total_deaths)/MAX(population) * 100 AS percent_deaths,
MAX(total_deaths)/MAX(total_cases) * 100 AS fatality_rate FROM covid_deaths
WHERE continent != "nan"
GROUP BY location
ORDER BY location;

WITH cte AS(
SELECT continent, location AS country, MAX(population) AS population, 
MAX(total_cases) AS total_cases, MAX(total_deaths) AS total_deaths,
MAX(total_cases)/MAX(population) * 100 AS percent_cases, 
MAX(total_deaths)/MAX(population) * 100 AS percent_deaths,
MAX(total_deaths)/MAX(total_cases) * 100 AS fatality_rate FROM covid_deaths
WHERE continent != "nan"
GROUP BY location
ORDER BY location)

SELECT MIN(total_cases), MAX(total_cases), MAX(total_deaths), MIN(total_deaths) FROM cte;



SELECT * FROM covid_deaths;



SELECT location, date, population, new_cases, new_deaths FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;
