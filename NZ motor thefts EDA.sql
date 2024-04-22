-- 1. What day of the week are vehicles most often stolen? 
 
select day, count(*) as number_of_thefts from 
 (select *, extract(day from date_stolen) as day_num, to_char(date_stolen, 'Day') as Day from stolen_vehicles)
  group by day
  order by number_of_thefts desc
  limit 1
  
-- 2. What day of the week are vehicles least often stolen? 
  
  select day, count(*) as number_of_thefts from 
  (select *, extract(day from date_stolen) as day_num, to_char(date_stolen, 'Day') as Day from stolen_vehicles)
   group by day
   order by number_of_thefts asc
   limit 1

-- 3. What make of vehicles are most often stolen?

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
limit 10

-- 4. What vehicle types are stolen most often

select vehicle_type, count(*) as number_of_thefts
from stolen_vehicles
group by vehicle_type
order by number_of_thefts desc
limit 10

-- 5. What type of vehicle is most stolen by region?

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

-- 6. What makes of vehicles are stolen least often?

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
order by number_of_thefts 
limit 10

-- 7. What vehicle types are stolen least often?

select vehicle_type, count(*) as number_of_thefts
from stolen_vehicles
group by vehicle_type
order by number_of_thefts 
limit 10

-- 8. What type of vehicles are stolen least often by region?

select * from
(select region, vehicle_type, number_of_thefts,
dense_rank() over(partition by region order by number_of_thefts asc) as Rank from
(select region, vehicle_type, count(*) as number_of_thefts from
(select *,
(select region from locations where stolen_vehicles.location_id=locations.location_id),
(select make_name from make_details where stolen_vehicles.make_id=make_details.make_id)
from stolen_vehicles)
group by vehicle_type, region
order by region, number_of_thefts asc))
where rank<=3

-- 9. Which regions have the most and least number of stolen vehicles, and what are their characteristics?

select region, max(population) as population, max(density) as density, count(*) as number_of_thefts from
(select *,
(select region from locations where stolen_vehicles.location_id=locations.location_id),
(select population from locations where stolen_vehicles.location_id=locations.location_id),
(select density from locations where stolen_vehicles.location_id=locations.location_id)
from stolen_vehicles)
group by region
order by number_of_thefts desc
