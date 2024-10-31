-- 1. population of airport
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
);
commit;

-- 2. population of route
insert into avi_route
(
   effective_date,
   route_id,
   route_name,
   dep_airport_id,
   trg_airport_id,
   route_length
)
select to_date(&p_effective_date,'yyyymmdd') as effective_date,
       dep.airport_id||'_'||trg.airport_id as route_id,
       dep.airport_name||' to '||trg.airport_name as route_name,
       dep.airport_id as dep_airport_id,
       trg.airport_id as trg_airport_id,
       1000 as route_length      
from avi_airport dep
     left join avi_airport trg
    on dep.airport_id<>trg.airport_id
order by dep.airport_id, trg.airport_id;
commit;

drop table avi_route_realization;

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
select to_date(:p_value_date,'yyyymmdd') as effective_date,
       rou.route_id,
       rou.route_id||'_'||to_char(route_realization_date,'yyyymmdd') as route_realization_id,
       'Airbus A340-200' as aircraft_type,
       sched.route_realization_date as route_start_date,
       sched.route_realization_date as route_end_date,
       rou.route_length*1000 as route_realization_cost
from avi_route rou
     left join (
               select TRUNC(trunc(to_date(:p_value_date,'yyyymmdd'),'mm'), 'iw') + 7 - 1/86400 as route_realization_date, 1 as sched_num from dual
               union select TRUNC(trunc(to_date(:p_value_date,'yyyymmdd'),'mm'), 'iw') + 14 - 1/86400 as route_realization_date, 2 as sched_num from dual
               union select TRUNC(trunc(to_date(:p_value_date,'yyyymmdd'),'mm'), 'iw') + 21 - 1/86400 as route_realization_date, 3 as sched_num from dual
               union select TRUNC(trunc(to_date(:p_value_date,'yyyymmdd'),'mm'), 'iw') + 28 - 1/86400 as route_realization_date, 4 as sched_num from dual
               ) sched
     on 1=1 and to_char(route_realization_date,'yyyymm')=to_char(to_date(:p_value_date,'yyyymmdd'),'yyyymm');
commit;

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
select to_date(:p_value_date,'yyyymmdd') as effective_date,
       rownum,
       upper(c.country)||'_'||upper(f.first_name)||'_'||upper(l.last_name) as passenger_id,
       f.first_name,
       l.last_name,
       c.country,
       lower(f.first_name||l.last_name||'_'||c.country||'@gmail_com') as email
from first_name f
     left join last_name l on 1=1
     left join country c on 1=1;
commit;

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
select to_date(:p_value_date,'yyyymmdd') as effective_date,
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
commit;