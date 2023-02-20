Select *
from PortfolioProjects..CovidDeaths


Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths in Poland
-- Shows likelihood of dying if you contract covid in Poland
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where location like '%Poland%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProjects..CovidDeaths
where location like '%Poland%'
order by 1,2

-- Looking at Coutries with highest infection rate compred to population

Select Location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProjects..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with highest death count per population

Select Location,  MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

-- Showing Continents with highest death count per population

Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
where continent is not null
order by 1,2


-- Looking at total population vs vaccinations

Select  death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, 
	sum(convert(bigint, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING)
	as RollingPeopleVaccinated, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths death
join PortfolioProjects..CovidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
order by 2,3



-- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, 
	sum(convert(bigint, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING)
	as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths death
join PortfolioProjects..CovidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Tabel

Drop table if exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, 
	sum(convert(bigint, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING)
	as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths death
join PortfolioProjects..CovidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
--where death.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, vaccine.new_vaccinations, 
	sum(convert(bigint, vaccine.new_vaccinations)) over (partition by death.location order by death.location, death.date ROWS UNBOUNDED PRECEDING)
	as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100
from PortfolioProjects..CovidDeaths death
join PortfolioProjects..CovidVaccinations vaccine
	on death.location = vaccine.location
	and death.date = vaccine.date
where death.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated