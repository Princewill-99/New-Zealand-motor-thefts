# New Zealand Vehicle Thefts Analysis
![](picture.jpg)

## Project Overview
This data analysis project is aimed at providing insights into the trends of motor vehicle thefts in New Zealand over a 7 month period from October 2021 to April 2022. By analyzing various aspects of the data, we seek to identify trends, make recommendations, and gain deeper understanding of the thefts of motor vehicles in New Zealand.

## Data Sources
Three datasets where used in this analysis;
- locations: This dataset contains the regions of New Zealand and their population characteristics i.e. population and density.
- Make Details: This is the "Make_details.xlsx" dataset, and it contains the characteristics of each vehicle identified by a unique vehicle_id.
- Stolen Vehicles: This is the "stolen_vehicles.xlsx" dataset, and it contains details of each theft.

## Tools Used
- Microsoft Excel – Data cleaning
- SQL – Data Analysis
- Tableau – Data visualization/ creating reports

## Project Questions
1. What day of the week are vehicles most often stolen?
2. What day of the week are vehicles least often stolen?
3. What make of vehicles are most often stolen?
4. What vehicle types are stolen most often
5. What type of vehicle is most stolen by region?
6. What makes of vehicles are stolen least often?
7. What vehicle types are stolen least often?
8. What type of vehicles are stolen least often by region?
9. Which regions have the most and least number of stolen vehicles, and what are their characteristics?

## Data Cleaning/Preparation
We began the project by preparing the data which involved:
-	Loading the data into the spreadsheet software (Microsoft Excel). The data consists of three tables and each of the tables where loaded and inspected.
-	Missing values and duplicate values were handled.
-	The data was cleaned and formatted. The data types of some columns were changed so as to enable smooth synchrony of the data with SQL.

## Data Analysis
We began our analysis of the data. We imported the data into the postgresql server and began to explore the data. Some tasks performed include:
-	Identifying the distinct months and years covered by the analysis using the query below:
```sql
select month, year from
(select extract(Month from date_stolen) as Month_num, to_char(date_stolen, 'Month') as month, extract(year from date_stolen) as Year
from stolen_vehicles
group by Month_num, month, Year
Order by Year, Month_num)
```
-	Identifying the number of thefts associated with each day of the week:

```sql
select day, count(*) as number_of_thefts from 
 (select *, extract(day from date_stolen) as day_num, to_char(date_stolen, 'Day') as Day from stolen_vehicles)
  group by day
  order by number_of_thefts desc
```

-	Identifying the number of thefts associated with each make of vehicle. “Make” here refers to the brand of the vehicle, e.g. Toyota, Honda etc:

```sql
select 
a.make_id,
a.number_of_thefts,
b.make_name,
b.make_type
from
(select make_id, count(*) as number_of_thefts
from stolen_vehicles
group by make_id
order by number_of_thefts desc) as a
inner join make_details as b
on a.make_id = b.make_id
order by number_of_thefts desc
```

-	Identifying the number of thefts associated with each vehicle type. Vehicle type refers to the type of vehicle e.g roadbike, trailer etc:

```sql
select vehicle_type, count(*) as number_of_thefts
from stolen_vehicles
group by vehicle_type
order by number_of_thefts desc
```

-	Identifying the top three vehicle types with highest number of thefts, categorized by each region:

```sql
select * from
(select region, vehicle_type, number_of_thefts,
dense_rank() over(partition by region order by number_of_thefts desc) as Rank from
(select region, vehicle_type, count(*) as number_of_thefts from
(select *,
(select region from locations where stolen_vehicles.location_id=locations.location_id),
(select make_name from make_details where stolen_vehicles.make_id=make_details.make_id)
from stolen_vehicles)
group by vehicle_type, region
order by region, number_of_thefts desc))
where rank<=3
```

-	The regions with the highest number of thefts, along with their population characteristics:

```sql
select region, max(population) as population, max(density) as density, count(*) as number_of_thefts from
(select *,
(select region from locations where stolen_vehicles.location_id=locations.location_id),
(select population from locations where stolen_vehicles.location_id=locations.location_id),
(select density from locations where stolen_vehicles.location_id=locations.location_id)
from stolen_vehicles)
group by region
order by number_of_thefts desc
```

## Results/Findings
![Tableau dashboard](https://github.com/Princewill-99/New-Zealand-motor-thefts/assets/155654312/50463e81-98cf-4933-a473-824d6550cdae)

-	Total Number of vehicle thefts for the period was 4,553, with an average of 650 thefts each month.
-	Auckland region had the highest number of thefts at 1,638. This is much higher than second highest ranking region, Canterbury, which had 660 thefts.
-	Stationwagon was the most stolen vehicle type, with 945 total thefts.
-	Vehicles were stolen most on Monday, which had 767 thefts, followed by Tuesday, Which had 711 thefts, and Friday, with 655 thefts.
-	Toyota was the most stolen vehicle make type, with 716 thefts.
-	95% of vehicles stolen were standard class, with luxury class consisting of about 4%.
-	There was a high positive correlation between the number of thefts in a region and the population of the region.
-	Thefts each month rose steadily from October 2021, reaching a peak of 1053 in March 2022, and then falling drastically to 329 in April 2022.
You can interact with the report of the analysis ![here](https://public.tableau.com/app/profile/princewill.chidera/viz/NewZealandvehicletheftdashboard/Dashboard1)

## Recommendations
- Security measures should be tightened more in areas with high population and denstiy.
- Increased surveillanced and security measures, esppecially on Mondays, Tuesdays and Fridays.
- Stationwagons along with other frequentlystolen vehicle types should be equipped with theft prevention measures such as stronger windows, tougher and stronger lock systems and alarm systems.

 

