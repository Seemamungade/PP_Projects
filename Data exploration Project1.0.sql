use schema2;
show tables;

Select* from cowiddeathsdata
order by 3,4;

select* from cowidvacinationdata;

Select location, date, total_cases, new_cases, total_deaths, population from cowiddeathsdata
order by 1, 2;

-- calculating Death Percentage
 Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
 from cowiddeathsdata 
 where location = "India" 
 order by 1, 2;
 
 -- percentage of people affected by Covid
 Select location, date, new_cases, total_deaths, (total_cases/population)*100 as affected_Percentage
 from cowiddeathsdata 
 where location = "India" 
 order by 1, 2;
 
 -- Locationwise Total deaths due to covid
 Select location, sum(total_deaths) as Total_death
 from cowiddeathsdata 
 group by location;
 
 -- moratality rate per 1M
 select location, date, population, total_deaths, (total_deaths/(1000000))  moratality_rate
 from cowiddeathsdata;
 
-- Looking at total cases vs Total deaths
-- What percentage of population got covid
Select location, date, total_cases, population, (total_cases/population)*100 as Covidgot_Percentage
from cowiddeathsdata 
where location = "India" 
order by 1, 2;
 
-- Looking at Country with highest Infection rate campared to population 
Select location, MAX(total_cases) as highest_infe_count, population, Max(total_cases/population)*100 as Percentage_infection_rate
from cowiddeathsdata 
-- where location = "India" 
group by location,population
order by Percentage_infection_rate DESC;

-- Showing country with highest Death count
Select location, MAX(total_deaths) as highest_Death_count 
from cowiddeathsdata 
where continent is not null 
group by location
order by highest_Death_count DESC;

-- Showing Continent with highest Death count
SELECT 
    continent, MAX(total_deaths) AS highest_Death_count
FROM
    cowiddeathsdata
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY highest_Death_count DESC;

-- Global Numbers
select date, sum(new_cases) as sumNCase, sum(cast(new_deaths as float)) as SumNDeaths
from cowiddeathsdata 
where continent is not null
group by date
order by 1,2;

select date, sum(new_cases) as sumNCase, sum(cast(new_deaths as float)) as SumNDeaths, Sum(cast(new_deaths as float))/SUM(new_cases)*100 as newdeath_percent
from cowiddeathsdata 
where continent is not null
group by date
order by 1,2;

-- Total Sum of Newcases , Deaths and total percentage of Deaths
select  sum(new_cases) as sumNCase, sum(cast(new_deaths as float)) as SumNDeaths, Sum(cast(new_deaths as float))/SUM(new_cases)*100 as newdeath_percent
from cowiddeathsdata 
where continent is not null
-- group by date
order by 1,2;


select continent, max(cast(total_deaths as float)) as totaldeathcount
from cowiddeathsdata
where continent is not null
group by continent
order by Totaldeathcount desc;
-- select* from cowiddeathsdata
select* from cowidvacinationdata;


-- Joining two Tables
select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations 
from cowiddeathsdata as dth
Join cowidvacinationdata as vac
on dth.location = vac.location and dth.date = vac.date;

-- Running sum for New vacintion
select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, 
sum( vac.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as runningsum_vacination
from cowiddeathsdata as dth
Join cowidvacinationdata as vac
on dth.location = vac.location and dth.date = vac.date;

-- Using CTE
with popvsvac 
(continent, location, date, population, new_vaccinations, runningsum_vacination) 
as
(select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, 
sum( vac.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as runningsum_vacination
from cowiddeathsdata as dth
Join cowidvacinationdata as vac
on dth.location = vac.location and dth.date = vac.date)
select *, (runningsum_vacination/population)*100  
from popvsvac;

-- create view to 
view percetageD as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
 from cowiddeathsdata;







