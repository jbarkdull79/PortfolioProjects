Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


Select *
From PortfolioProject..CovidDeaths
Where continent is not null


--Looking at Total Cases vs Deaths
--Shows likelihood of dying if you  contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got Covid 
Select Location, date, total_cases, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected 
From PortfolioProject..CovidDeaths
where total_cases is not null
and location like '%states%'


--Looking at Countries with Highest Infection Rate compared to populationercentPopulationInfected 
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected 
From PortfolioProject..CovidDeaths
Where total_cases is not null
--where location like '%states%'
Group by location, Population
order by PercentPopulationInfected desc


--LET'S BREAK THINGS DOWN BY CONTINENT
Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount desc


--Showing Countries with Highest Death Count per Population
Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
Where continent is null
and total_deaths is not null
Group by location
order by TotalDeathCount desc

--Showing continents with the highest death count
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
Where continent is not null
and total_deaths is not null
Group by continent
order by TotalDeathCount desc


-- Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
and new_cases is not null
Group by date
order by 1,2


--0Join both table 
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
     On dea.location = vac.location
	 and dea.date = vac.date


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and population is not null
order by 2,3


-- USE CTE
With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and population is not null
--order by 2,3
)
	 
Select *, (RollingPeopleVaccinated/Population)*100 as Percentpopulationvaccinated
From PopvsVac
	


	 
-- TEMPTable 
DROP tABLE IF exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
and population is not null
--order by 2,3
 
Select *, (RollingPeopleVaccinated/Population)*100 as Percentpopulationvaccinated
From #PercentPopulationVaccinated

  



  -- Create view to store data for later visualizations

  Create View PercentPopulationVaccinated as 
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
and population is not null
--order by 2,3


Select *
From PercentPopulationVaccinated









