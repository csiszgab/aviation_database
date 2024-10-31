insert into sql_script_head
( sql_script_set_id, sql_script_id, sql_script_title, sql_script_short_description)
select 'AVI_LOADER' as sql_script_set_id,'AVI_01' as sql_script_id, 'AVI_AIRPORT_LOADER' as sql_script_title, 'Loader of the AVI_AIRPORT table' as sql_script_short_description from dual
union select 'AVI_LOADER' as sql_script_set_id,'AVI_02' as sql_script_id, 'AVI_PASSENGER_LOADER' as sql_script_title, 'Loader of the AVI_PASSENGER table' as sql_script_short_description from dual
union select 'AVI_LOADER' as sql_script_set_id,'AVI_03' as sql_script_id, 'AVI_ROUTE_LOADER' as sql_script_title, 'Loader of the AVI_ROUTE_LOADER table' as sql_script_short_description from dual
union select 'AVI_LOADER' as sql_script_set_id,'AVI_04' as sql_script_id, 'AVI_ROUTE_REALIZATION_LOADER' as sql_script_title, 'Loader of the AVI_ROUTE_REALIZATION_LOADER table' as sql_script_short_description from dual
union select 'AVI_LOADER' as sql_script_set_id,'AVI_05' as sql_script_id, 'AVI_ROUTE_REALIZATION_PASSENGER_LOADER' as sql_script_title, 'Loader of the AVI_ROUTE_REALIZATION_PASSENGER_LOADER table' as sql_script_short_description from dual;
commit;

update sql_script_head
set sql_script_long_description='Populating AVI_AIRPORT table for specific EFFECTIVE_DATE with manual, hardcoded values.'
where sql_script_id='AVI_01';

update sql_script_head
set sql_script_long_description='Populating AVI_PASSENGER table for specific EFFECTIVE_DATE with manual, hardcoded values.'
where sql_script_id='AVI_02';

update sql_script_head
set sql_script_long_description='Populating AVI_ROUTE table for specific EFFECTIVE_DATE based on AVI_AIRPORT table. Each route lenght is constant 1000.'
where sql_script_id='AVI_03';

update sql_script_head
set sql_script_long_description='Populating AVI_ROUTE_REALIZATION table for specific EFFECTIVE_DATE based on AVI_ROUTE table. Every route is realized once a week.'
where sql_script_id='AVI_04';

update sql_script_head
set sql_script_long_description='Populating AVI_ROUTE_REALIZATION_PASSENGER table for specific EFFECTIVE_DATE based on AVI_ROUTE_REALIZATION and AVI_PASSENGER table. Passengers are chosen randomly, flight capacity is also accounted for.'
where sql_script_id='AVI_05';

select * from sql_script_version

insert into sql_script_version
( sql_script_id, sql_script_version, sql_script_version_rownum, sql_script_version_date)
select 'AVI_01' as sql_script_id, 'V00.01.00' as sql_script_version, 1 as sql_script_version_rownum, to_date(:p_value_date,'yyyymmdd') as sql_script_version_date from dual
union select 'AVI_02' as sql_script_id, 'V00.01.00' as sql_script_version,1 as sql_script_version_rownum, to_date(:p_value_date,'yyyymmdd') as sql_script_version_date  from dual
union select 'AVI_03' as sql_script_id, 'V00.01.00' as sql_script_version,1 as sql_script_version_rownum, to_date(:p_value_date,'yyyymmdd') as sql_script_version_date from dual
union select 'AVI_04' as sql_script_id, 'V00.01.00' as sql_script_version,1 as sql_script_version_rownum, to_date(:p_value_date,'yyyymmdd') as sql_script_version_date from dual
union select 'AVI_05' as sql_script_id, 'V00.01.00' as sql_script_version,1 as sql_script_version_rownum, to_date(:p_value_date,'yyyymmdd') as sql_script_version_date  from dual;
commit;

select * from sql_script_version

update sql_script_version
set sql_script_version_description='Populating AVI_AIRPORT table for specific EFFECTIVE_DATE with manual, hardcoded values. Small number of Airports, no latitude and longitude coordinates. Country information is not available.',
    sql_version_change_description='Initial version.'
where sql_script_id='AVI_01' and sql_script_version='V00.01.00';

update sql_script_version
set sql_script_version_description='Populating AVI_PASSENGER table for specific EFFECTIVE_DATE with manual, hardcoded values. Only English names (10 popular first names and last names with cartesian product, 10 country is chosen as well => 1000 passenger generated. No date of birth, gender, etc is available. Instead of country, citizenship would be better.',
    sql_version_change_description='Initial version.'
where sql_script_id='AVI_02' and sql_script_version='V00.01.00';

update sql_script_version
set sql_script_version_description='Populating AVI_ROUTE table for specific EFFECTIVE_DATE. Route exists between two DIFFERENT airports. Route length is hardcoded to 1000 km.',
    sql_version_change_description='Initial version.'
where sql_script_id='AVI_03' and sql_script_version='V00.01.00';

update sql_script_version
set sql_script_version_description='Populating AVI_ROUTE_REALIZATION table. Contains all route realizations for given month. Schedule is hard coded, each fligh is scheduled weekly, on first day of week. Aircraft type is harcoded to Airbus A340-200',
    sql_version_change_description='Initial version.'
where sql_script_id='AVI_04' and sql_script_version='V00.01.00';

update sql_script_version
set sql_script_version_description='Populating AVI_ROUTE_REALIZATION_PASSENGER table for specific EFFECTIVE_DATE. Because aircraft type is constant, passenger limit is constant as well (385). Passengers chosen randomly. One pasenger is possible to take more than one flight at a time. Contradiction.',
    sql_version_change_description='Initial version.'
where sql_script_id='AVI_05' and sql_script_version='V00.01.00';
commit;

insert into sql_script
(sql_script_id, sql_script_version, creation_date, lt_modification_date, sql_num, sql_id, sql_target_table)
select s.sql_script_id, 'V00.01.00', to_date(:p_value_date,'yyyymmdd') as creation_date, to_date(:p_value_date,'yyyymmdd') as last_modification_date,1, s.sql_id, s.sql_target_table
from (
     select 'AVI_01' as sql_script_id, 'AVI_01_ETL_01' as sql_id, 'AVI_AIRPORT' as sql_target_table from dual
     union select 'AVI_02' as sql_script_id, 'AVI_02_ETL_01' as sql_id, 'AVI_PASSENGER' as sql_target_table from dual
     union select 'AVI_03' as sql_script_id, 'AVI_03_ETL_01' as sql_id, 'AVI_ROUTE' as sql_target_table from dual
     union select 'AVI_04' as sql_script_id, 'AVI_04_ETL_01' as sql_id, 'AVI_ROUTE_REALIZATION' as sql_target_table from dual
     union select 'AVI_05' as sql_script_id, 'AVI_05_ETL_01' as sql_id, 'AVI_ROUTE_REALIZATION_PASSENGER' as sql_target_table from dual
     ) s;
commit;

select rowid, s.* from sql_script s;

-- 1. population of airport
update sql_script
set sql_param=q'[
insert into avi_airport
(airport_id,airport_name, airport_capacity, city, country)
select airport_id, airport_name, Null as aiport_capacity, city, Null as airport_country
from (
select  'Abu Dhabi' as city,'Abu Dhabi International Airport' as airport_name,'AUH' as airport_id from dual
union select  'Colombo','Bandaranaike International Airport','CMB' from dual
union select  'Doha','Doha International Airport','DOH' from dual
union select  'Dubai','Dubai International Airport','DXB' from dual
union select  'Frankfurt','Frankfurt International Airport','FRA' from dual
union select  'Dhaka','Hazrat Shahjalal International Airport','DAC' from dual
union select  'Hong Kong','Hong Kong International Airport','HKG' from dual
union select  'Istanbul','Istanbul Airport','IST' from dual
union select  'New York','John F Kennedy International Airport','JFK' from dual
union select  'Kuala Lumpur','Kuala Lumpur International Airport','KUL' from dual
union select  'Kuwait City','Kuwait International Airport','KWI' from dual
union select  'London	London','Gatwick Airport','LGW' from dual
union select  'London	London','Heathrow Airport','LCY' from dual
union select  'Los Angeles','Los Angeles International Airport','LAX' from dual
union select  'Lagos','Murtala Muhammed Airport','LOS' from dual
union select  'Muscat','Muscat International Airport','MCT' from dual
union select  'Tokyo','Narita International Airport','NRT' from dual
union select  'Tokyo','Tokyo International Airport','NRT' from dual
union select  'Chicago','O Hare International Airport','ORD' from dual
union select  'Paris','Paris Charles de Gaulle Airport','CDG' from dual
union select  'San Francisco','San Francisco International Airport','SFO' from dual
union select  'Singapore','Singapore Changi Airport','SIN' from dual
union select  'Bangkok','Suvarnabhumi International Airport','BKK' from dual
union select  'Tokyo','Narita International Airport','NRT' from dual
union select  'Tokyo','Tokyo International Airport','NRT' from dual
union select  'Toronto','Toronto Pearson International Airport','YYZ' from dual
union select  'Kathmandu','Tribhuvan International Airport','KTM' from dual
)
]'
where sql_script_id='AVI_01' and sql_id='AVI_01_ETL_01';
commit;

-- 3. population of route

update sql_script
set sql_param=q'[
insert into avi_route
(
   effective_date,
   route_id,
   route_name,
   dep_airport_id,
   trg_airport_id,
   route_length
)
select to_date(@p_effective_date,'yyyymmdd') as effective_date,
       dep.airport_id||'_'||trg.airport_id as route_id,
       dep.airport_name||' to '||trg.airport_name as route_name,
       dep.airport_id as dep_airport_id,
       trg.airport_id as trg_airport_id,
       1000 as route_length      
from avi_airport dep
     left join avi_airport trg
    on dep.airport_id<>trg.airport_id
order by dep.airport_id, trg.airport_id;
]'
where sql_script_id='AVI_03' and sql_id='AVI_03_ETL_01';
commit;

commit;

drop table avi_route_realization;

update sql_script
set sql_param=q'[
insert into avi_route_realization
(
   effective_date,
   route_id,
   route_realization_id,
   aircraft_type,
   route_start_date,
   route_end_date,
   route_realization_cost
)
select to_date(@p_value_date,'yyyymmdd') as effective_date,
       rou.route_id,
       rou.route_id||'_'||to_char(route_realization_date,'yyyymmdd') as route_realization_id,
       'Airbus A340-200' as aircraft_type,
       sched.route_realization_date as route_start_date,
       sched.route_realization_date as route_end_date,
       rou.route_length*1000 as route_realization_cost
from avi_route rou
     left join (
               select TRUNC(trunc(to_date(@p_value_date,'yyyymmdd'),'mm'), 'iw') + 7 - 1/86400 as route_realization_date, 1 as sched_num from dual
               union select TRUNC(trunc(to_date(@p_value_date,'yyyymmdd'),'mm'), 'iw') + 14 - 1/86400 as route_realization_date, 2 as sched_num from dual
               union select TRUNC(trunc(to_date(@p_value_date,'yyyymmdd'),'mm'), 'iw') + 21 - 1/86400 as route_realization_date, 3 as sched_num from dual
               union select TRUNC(trunc(to_date(@p_value_date,'yyyymmdd'),'mm'), 'iw') + 28 - 1/86400 as route_realization_date, 4 as sched_num from dual
               ) sched
     on 1=1 and to_char(route_realization_date,'yyyymm')=to_char(to_date(@p_value_date,'yyyymmdd'),'yyyymm')
]'
where sql_script_id='AVI_04' and sql_id='AVI_04_ETL_01';
commit;
commit;

select * from sql_script

update sql_script
set sql_param=q'[
insert into avi_passenger 
(
   effective_date,
   passenger_num,
   passenger_id,
   first_name,
   last_name,
   country,
   email_address -- can be generated from first and last name
)
with first_name as
(
select 'John' as first_name from dual
union select 'Richard' as first_name from dual
union select 'Joe' as first_name from dual
union select 'Harry' as first_name from dual
union select 'William' as first_name from dual
union select 'Tom' as first_name from dual
union select 'Michael' as first_name from dual
union select 'Parker' as first_name from dual
union select 'Paul' as first_name from dual
union select 'Luke' as first_name from dual
), last_name as
(
select 'Smith' as last_name from dual
union select 'Taylor' as last_name from dual
union select 'Johnson' as last_name from dual
union select 'Wright' as last_name from dual
union select 'Harris' as last_name from dual
union select 'Turner' as last_name from dual
union select 'Cooper' as last_name from dual
union select 'King' as last_name from dual
union select 'Brown' as last_name from dual
union select 'Walker' as last_name from dual
), country as
(
select 'United States' as country from dual
union select 'Germany' as country from dual
union select 'France' as country from dual
union select 'Dubai' as country from dual
union select 'China' as country from dual
union select 'Turkey' as country from dual
union select 'Great Britain' as country from dual
union select 'Japan' as country from dual
union select 'Canada' as country from dual
union select 'Bangladesh' as country from dual
)
select to_date(@p_value_date,'yyyymmdd') as effective_date,
       rownum,
       upper(c.country)||'_'||upper(f.first_name)||'_'||upper(l.last_name) as passenger_id,
       f.first_name,
       l.last_name,
       c.country,
       lower(f.first_name||l.last_name||'_'||c.country||'@gmail_com') as email
from first_name f
     left join last_name l on 1=1
     left join country c on 1=1;
]'
where sql_script_id='AVI_02' and sql_id='AVI_02_ETL_01';
commit;

update sql_script
set sql_param=q'[
insert into avi_route_realization_passenger
(
   effective_date,
   route_realization_id,
   passenger_id,
   seat_number,
   seat_type
   flight_price
);
select rp.effective_date,
       rp.route_realization_id,
       rp.passenger_id,
       rp.seat_number,
       rp.seat_type,
       rp.flight_price       
from (
select rp.*,
       sum(present_flag) over (partition by 1 order by rownum rows between unbounded preceding and 0 following) as flag_rownum
from (
select to_date(@p_value_date,'yyyymmdd') as effective_date,
       rr.route_realization_id,
       p.passenger_id,
       rownum as seat_number,
       'A' as seat_type,
       100 as flight_price,
       round(dbms_random.value(0,1)) as present_flag,
       passenger_limit
from avi_route_realization rr
     left join avi_passenger p on 1=1
     left join (select 385 as passenger_limit from dual) l on 1=1
) rp
) rp
where flag_rownum<=passenger_limit and present_flag=1;
]'
where sql_script_id='AVI_05' and sql_id='AVI_05_ETL_01';
commit;

select * from sql_script order by sql_script_id;

