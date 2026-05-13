create database Ola;
use Ola;

CREATE TABLE bookings (
    Date DATETIME,
    Time TIME,
    Booking_ID VARCHAR(20),
    Booking_Status VARCHAR(50),
    Customer_ID VARCHAR(20),
    Vehicle_Type VARCHAR(50),
    Pickup_Location VARCHAR(100),
    Drop_Location VARCHAR(100),
    V_TAT FLOAT,
    C_TAT FLOAT,
    Canceled_Rides_by_Customer VARCHAR(255),
    Canceled_Rides_by_Driver VARCHAR(255),
    Incomplete_Rides VARCHAR(20),
    Incomplete_Rides_Reason VARCHAR(255),
    Booking_Value INT,
    Payment_Method VARCHAR(50),
    Ride_Distance FLOAT,
    Driver_Ratings FLOAT,
    Customer_Rating FLOAT,
    Vehicle_Images TEXT
);

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'D:/Bookings.xlsx - July.csv'
INTO TABLE bookings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select count(*) from bookings;
-- 1. Retrieve all successful bookings:

create view Successful_Bookings as
select * from bookings
where Booking_Status = 'Success';

select * from Successful_Bookings;


-- 2. Find the average ride distance for each vehicle type:

create view ride_distance_for_each_vehicle as
select Vehicle_Type, avg(Ride_Distance)
as avg_distance from bookings
group by Vehicle_Type;

select * from ride_distance_for_each_vehicle;


-- 3. Get the total number of cancelled rides by customers:
create view cancelled_rides_by_customers as
select count(*) from bookings
where  Booking_Status ='Canceled by Customer';

select * from cancelled_rides_by_customers;


-- 4. List the top 5 customers who booked the highest number of rides:
create view top_5_customers as
select Customer_ID , count(Booking_ID) as total_rides
from bookings
group by Customer_ID
order by total_rides desc limit 5;

select * from top_5_customers;

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create view rides_cancelled_by_drivers_P_C_Issues as
select count(*) from bookings
where  Canceled_Rides_by_Driver ='Personal & Car related issue';

select * from rides_cancelled_by_drivers_P_C_Issues;

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view max_min_driver_rating as
select max(Driver_Ratings) as max_rating,
min(Driver_Ratings) as min_rating 
from bookings where Vehicle_Type='Prime Sedan';

select * from max_min_driver_rating;

-- 7. Retrieve all rides where payment was made using UPI:
create view UPI_Payment as
select * from bookings 
where Payment_Method = 'UPI';

select * from UPI_Payment;

-- 8. Find the average customer rating per vehicle type:
create view avg_customer_rating as
select Vehicle_Type , avg(Customer_Rating) as avg_customer_rating
from bookings
group by Vehicle_Type;

select * from avg_customer_rating;

-- 9. Calculate the total booking value of rides completed successfully:
create view total_successful_ride_value as 
select sum(Booking_Value)as total_successful_ride_value
from bookings
where  Booking_Status ='Success';

select * from total_successful_ride_value;

-- 10. List all incomplete rides along with the reason:
create view Incomplete_rides_reason as
select Booking_ID , Incomplete_Rides_Reason
from bookings
where Incomplete_Rides = 'Yes';

select * from Incomplete_rides_reason;
