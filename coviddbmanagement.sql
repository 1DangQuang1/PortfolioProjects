select * from PortfolioProject..CovidDeaths$ 
where continent is not null
ORDER BY 3,4;

select location,date,total_cases,total_deaths,new_cases,(total_deaths/total_cases)*100 as DeathPercentage,population	
from PortfolioProject..CovidDeaths$ 
where location like '%vie%' and (date between '2020-01-28 00:00:00.000' and '2020-02-06 00:00:00.000')
order by 1;


select location,population,Max((total_cases/population))*100 as PercentPopulationInfected, max(total_cases) as HighestInfectionCount
from PortfolioProject..CovidDeaths$
group by location,population
order by PercentPopulationInfected desc;


select location,population,max(cast(total_deaths as int))as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location,population
order by TotalDeathsCount desc

select continent,max(cast(total_deaths as int))as TotalDeathsCount
from PortfolioProject..CovidDeaths$
where continent is not null	
group by continent
order by TotalDeathsCount desc;


select sum(new_cases) as NewInfection,sum (cast(new_deaths as int)) as TotalDeaths,(sum (cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths$ 
where continent is not null
--group by date 



with COVID_CTE(Location,Continent,date,population,new_vaccinations,RollingPeopleVaccinated)
as

(select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations ,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated 
from PortfolioProject..CovidVaccinations$ vac
join PortfolioProject..CovidDeaths$ dea
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null)
--ORDER BY 1,3)

select *,(RollingPeopleVaccinated/Population)*100 from COVID_CTE





drop table if exists #covid2020
create table #covid2020
(location nvarchar(255),
continent nvarchar(255),
date datetime ,
population bigint ,
new_vaccination numeric,
RollingPeopleVaccinated bigint,)

insert into #covid2020
select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations ,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated 
from PortfolioProject..CovidVaccinations$ vac
join PortfolioProject..CovidDeaths$ dea
on dea.date=vac.date and dea.location=vac.location
--where dea.continent is not null
--ORDER BY 1,3

select *, (RollingPeopleVaccinated/population)*100  as VaccinatedPercentage from #covid2020





create view covid2021 as 
select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations ,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated 
from PortfolioProject..CovidVaccinations$ vac
join PortfolioProject..CovidDeaths$ dea
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
--ORDER BY 1,3
select *, (RollingPeopleVaccinated/population)*100  as VaccinatedPercentage from covid2021