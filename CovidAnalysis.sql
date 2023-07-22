select * 
from Portfolioproject.dbo.Covid_Deaths$
order by 3,4

select * 
from Portfolioproject.dbo.Covid_Vaccinations$
order by 3,4

-- number of rows into our dataset

select count(*) as total_columns
from Portfolioproject..Covid_Deaths$

select count(*) as total_columns
from Portfolioproject..Covid_Vaccinations$

-- select the columns we want from the dataset

select location, date,population, total_cases, new_cases, total_deaths
from PortfolioProject..Covid_Deaths$
where continent is not null 
order by 1,2

--select dataset of India

select location, date,population, total_cases, new_cases, total_deaths
from PortfolioProject..Covid_Deaths$
where  location='India' and  continent is not null  
order by 1,2

-- total_cases vs total_deaths  

select location, date,total_cases, (total_deaths/total_cases) * 100 as death_rate
from PortfolioProject..Covid_Deaths$
where continent is not null  
order by 1,2

-- percentage of population infected with covid

select location, date,population,total_cases, (total_cases/population) * 100 as infected_rate
from PortfolioProject..Covid_Deaths$
where continent is not null  
order by 1,2

-- total death_count and total covid cases in a country 

select location,sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths
From PortfolioProject..Covid_Deaths$
Where continent is not null 
Group by location
order by totalcases desc

-- Top 3 countries with highest number of cases

select  top 3
location,sum(new_cases) as totalcases
From PortfolioProject..Covid_Deaths$
Where continent is not null 
Group by location
order by totalcases desc

-- Top 3 countries with highest number of covid deaths

select  top 3
location,sum(new_deaths) as totalcases
From PortfolioProject..Covid_Deaths$
Where continent is not null 
Group by location
order by totalcases desc

-- Countries with highest covid_rate compared to population

select location, population, sum(new_cases) as totalcovidcases,  sum((new_cases/population))*100 as CovidInfectedRate
from PortfolioProject..Covid_Deaths$
group by location, population
order by CovidInfectedRate desc

-- Total covid cases and deaths across the world per day

select date, sum(new_cases) as covidcases , sum(new_deaths)
from PortfolioProject..Covid_Deaths$
group by date
order by date asc

-- Total covid cases and deaths in a continent

select continent, sum(new_cases) as totalcovidcases, sum(new_deaths) as totaldeaths 
from PortfolioProject..Covid_Deaths$
where continent is not null 
group by continent
order by continent

-- Countries starting with letter "A" with total fully_vaccinated people 

select location, max(cast(people_fully_vaccinated as bigint)) as totalvaccinations
from PortfolioProject..Covid_Vaccinations$
where location like 'A%' and continent is not null 
group by location

-- joining two tables
-- countries with their population and total vaccinations count

select td.continent, td.location, td.population, sum(tv.new_vaccinations) as totalvaccinationcount
from PortfolioProject..Covid_Deaths$ td
join 
PortfolioProject..Covid_Vaccinations$ tv
	On td.location = tv.location
	and td.date = tv.date
where td.continent is not null 
group by td.continent,td.location,td.population

--Using Common Table Expression(CTE) 
--Percentage of people fully vaccinated compared to population

with virtualtable(continent, location, population, totalpeoplevaccinationcount) as 
(
Select td.continent,td.location, td.population, max(tv.people_fully_vaccinated) as totalpeoplevaccinationcount
from PortfolioProject..Covid_Deaths$ td
Join PortfolioProject..Covid_Vaccinations$ tv
	On td.location = tv.location
	and td.date = tv.date
where td.continent is not null
group by  td.continent, td.Location, td.Population
)
Select *,(totalpeoplevaccinationcount/population)*100 as vaccinationrate
From virtualtable


-- Using Temp Table to perform previous query

drop table if exists #vaccinationrate
create table #vaccinationrate(
continent nvarchar(255),
location nvarchar(255),
population float,
totalpeoplevaccinationcount float)
insert into #vaccinationrate
select td.continent,td.location,td.population,max(tv.people_fully_vaccinated) as totalpeoplevaccinationcount
from Portfolioproject..Covid_Deaths$ as td
Join PortfolioProject..Covid_Vaccinations$ as tv
	On td.location = tv.location
	and td.date = tv.date
where td.continent is not null
group by  td.continent, td.Location, td.Population
select *,(totalpeoplevaccinationcount/population)*100 as vaccinationrate
from #vaccinationrate

-- Creating a view 

go
create view vaccinationrate as
Select td.continent,td.location, td.population, max(tv.people_fully_vaccinated) as totalpeoplevaccinationcount
from PortfolioProject..Covid_Deaths$ as td
Join PortfolioProject..Covid_Vaccinations$ as tv
	On td.location = tv.location
	and td.date = tv.date
where td.continent is not null
group by  td.continent, td.Location, td.Population
go
select * from vaccinationrate

-- Creating a procedure to find total_cases,deaths and vaccinations in a specified country
go
create procedure country_covid @location nvarchar(255)
as
select td.location,td.date,td.total_cases,tv.total_vaccinations
from PortfolioProject..Covid_Deaths$ as td
Join PortfolioProject..Covid_Vaccinations$ as tv
	On td.location = tv.location
	and td.date = tv.date
where td.location=@location
go 
exec country_covid @location='Africa'





















































