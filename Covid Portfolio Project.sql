SELECT * 
FROM coviddeaths
WHERE continent IS NOT NULL
order by 3,4


--SELECT *
--FROM PortfolioProject..covidvaccinations
--order by 3,4

SELECT country, Date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2

-- Total cases vs Total deaths
SELECT country, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
ORDER BY 1,2

-- Deaths Percentage in United States
SELECT country, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE country like '%states%'
ORDER BY 1,2

-- Total cases vs population in United States
-- % of the United States population that got covid
SELECT country, Date, population, total_cases, (total_cases/population)*100 as Percentageofpopulationinfected
FROM coviddeaths
WHERE country like '%states%'
ORDER BY 1,2

-- Countries with Highest death count per population
SELECT country, date, MAX(cast(total_deaths as INT)) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY country
ORDER BY 2 DESC

-- Continent with Highest death count per population
SELECT Continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY Continent
ORDER BY 2 DESC

-- Total death count
SELECT SUM(cast(total_deaths as INT)) as TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL

--Global cases vs deaths
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths AS INT)) as total_deaths, (SUM(cast(new_deaths AS INT))/SUM(new_cases))*100 as DeathPercentage
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1,2 

--Total population vs Vaccinated
SELECT cd.continent, cd.country, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.country ORDER BY cd.country, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
	ON cd.country = cv.country
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

-- CREATING VIEW TO STORE DATA
CREATE VIEW RollingPeopleVaccinated AS

SELECT cd.continent, cd.country, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.country ORDER BY cd.country, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
	ON cd.country = cv.country
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

-- USING CTE TO PERFORM CALCULATION
WITH cte_test(continent, country, date, population, new_vaccinations, RollingPeopleVaccinated) AS
(
SELECT cd.continent, cd.country, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.country ORDER BY cd.country, cd.date) AS RollingPeopleVaccinated
FROM coviddeaths cd
JOIN covidvaccinations cv
	ON cd.country = cv.country
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT continent, country, population
FROM cte_test
order by 1, 3 desc

