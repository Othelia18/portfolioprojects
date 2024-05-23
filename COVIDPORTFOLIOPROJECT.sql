SELECT *
FROM covid_deaths
WHERE continent is not null
ORDER BY 3,4;

SELECT *
FROM covid_vaccinations
ORDER BY 3,4;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths;

-- looking at total deaths vs total cases

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE location LIKE '%fri%';

-- looking at total cases vs population

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PopulationPer
FROM covid_deaths
WHERE location LIKE '%fri%';

-- looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) AS HighestCases, MAX((total_cases/population))*100 AS PopulationPer
FROM covid_deaths
GROUP BY location, population
ORDER BY PopulationPer DESC;

-- showing countries with highest death count per population

SELECT Location, MAX(total_deaths) AS DeathCount
FROM covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY DeathCount DESC;


SELECT continent, MAX(total_deaths) AS DeathCount
FROM covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY DeathCount DESC;


-- global numbers

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPer
FROM covid_deaths
WHERE continent is not null
order by 1,2 ;


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

-- use cte

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;


-- temp table

CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null;

-- SELECT *, (RollingPeopleVaccinated/population)*100
-- FROM #PercentPopulationVaccinated;




CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null;


SELECT *
FROM PercentPopulationVaccinated;