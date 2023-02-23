-- First let's use union to make one big table with the information from all of the months of 2022
CREATE TABLE temp1(
ride_id varchar(30),
rideable_type varchar(20),
started_at VARCHAR(100),
ended_at VARCHAR(100),
start_station_name varchar(max),
start_station_id varchar(max),
end_station_name varchar (max),
end_station_id varchar (max),
start_lat real,
start_lng real,
end_lat real,
end_lng real,
member_casual varchar (10))

insert into temp1 
SELECT *
FROM A_202201
UNION
SELECT *
FROM A_202202
union
select*
from A_202203
union
SELECT *
FROM A_202204
union
SELECT *
FROM A_202205
union
SELECT *
FROM A_202206
union
SELECT *
FROM A_202207
union
SELECT *
FROM A_202208

-- insert the rest of the data

CREATE TABLE temp2(
ride_id varchar(30),
rideable_type varchar(20),
started_at VARCHAR(100),
ended_at VARCHAR(100),
start_station_name varchar(max),
start_station_id varchar(max),
end_station_name varchar (max),
end_station_id varchar (max),
start_lat real,
start_lng real,
end_lat real,
end_lng real,
member_casual varchar (10))
insert into temp2 
select *
from A_202209
union
select *
from A_202210
insert into temp2 
select * 
from A_202211
union
select *
from A_202212

insert into temp1
select*
from temp2
--adding 2 new columns 
alter table full_year 
add  ended_at_new datetime,
started_at_new datetime
-- setting their value
update full_year
set started_at_new = TRY_CAST(started_at as datetime)
update full_year
set ended_at_new = TRY_CAST(ended_at as datetime)

-- calculating trip duration

alter table full_year
add trip_duration int 
update full_year
set trip_duration = DATEDIFF(minute,started_at_new,ended_at_new)

--- figuering out the day of the week 
alter table full_year
add week_day varchar(50)

update full_year
set week_day = case
    when datepart(weekday, started_at) = 1 then 'Weekend'
    when datepart(weekday, started_at) = 7 then 'Weekend'
    else 'Weekday'
end
where isdate(started_at) = 1

select top 10000 *
from full_year

-- average trip duration for members and count

SELECT
week_day,
AVG(trip_duration) as average_trip_duration,
count(ride_id) as count_trips
from full_year
where member_casual = 'member'
group by week_day

-- average trip duration for causal riders and count

SELECT
week_day,
AVG(trip_duration) as average_trip_duration,
count(ride_id) as count_trips
from full_year
where member_casual = 'casual'
group by week_day
