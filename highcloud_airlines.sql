use highcloud_airlines;
describe maindata;
select * from maindata;
ALTER TABLE maindata MODIFY COLUMN `month` INT AFTER `year`;
select * , date(year|| '-' || month || '-' || day) as DateKey from maindata;
SELECT 
  CAST(YEAR AS CHAR(4)) || '-' || CAST(MONTH AS CHAR(2)) || '-' || CAST(DAY AS CHAR(2)) AS datekey
FROM maindata;
select * from order_date limit 5;

create view KPI1 as (
select year(order_date) as year ,month(order_date) as Month_no,monthname(order_date) as month_name,
case when month(order_date) in ('1','2','3') then 'Q1'
when month(order_date) in ('4','5','6') then 'Q2'
when  month(order_date) in ('7','8','9') then 'Q3'
else 'Q4'
end as quarter,

concat(year(order_date),'-',left(monthname(order_date),3)) as Yearmonth,
weekday(order_date) as weekDay_no,
dayname(order_date) as weekday_name,
case when month(order_date)>=4 then (month(order_date) -3)
else (month(order_date) +9) end as financial_month,

case when month(order_date) in ('4','5','6') then 'FQ1'
when month(order_date) in ('7','8','9') then 'FQ2'
when  month(order_date) in ('10','11','12') then 'FQ3'
else 'FQ4'end as financial_quarter
,case when weekday(order_date) >4 then "Weekend" else "Weekday" end as weekday_weekend
from  order_date
 );

select * from KPI1;


###kpi2###

#Yearly

select Year,
	round((sum(transported_passengers)/sum(available_seats) * 100),2) as 'LoadFactor%'
from maindata
group by year;

#monthly
select month,
round((sum(transported_passengers)/sum(available_seats)*100),2) as 'LoadFactor%'
from maindata
group by month;



#Quarterly

select 
    case 
        when month in (1, 2, 3) then 'Q1'
        when month in (4, 5, 6) then 'Q2'
        when month in (7, 8, 9) then 'Q3'
		else 'Q4'
    end as Quarter,
    round((sum(transported_passengers) / sum(available_seats) * 100), 2) as 'Loadfactor%'
from maindata
group by Quarter
order by field(Quarter, 'Q1', 'Q2', 'Q3', 'Q4');


##KPI3###
SELECT 
    carrier_name,
    ROUND((SUM(transported_passengers) / SUM(available_seats) * 100), 2) AS 'LoadFactor%'
FROM 
    maindata
GROUP BY 
  'LoadFactor%',   carrier_name
    order by  
     'LoadFactor%' desc
    limit 10;

###KPI4
select
	carrier_name,
    count(transported_passengers ) as Passengers_Preffered
from maindata
group by carrier_name
order by count(transported_passengers) desc
limit 10;

###KPI5
select
    'From - To City' as Routes,
    count(departures_performed) as No_of_Flights
from maindata
group by 'From - To City'
order by count(departures_performed) desc
limit 20;

###KPI6
SELECT
    CASE
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0')), '%Y-%m-%d')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    AVG('loadfactor%') AS Avg_Load_Factor
FROM maindata
GROUP BY Day_Type;


###KI7
select
	distance_group_ID as Distance_Group_ID,
    count('%Airline ID') as No_of_Flights
from maindata
group by distance_group_ID
order by count('%Airline ID') desc;

