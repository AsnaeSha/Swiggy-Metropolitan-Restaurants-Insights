-- CREATE DATABASE if not exists swiggy;

-- CREATE TABLE if not exists restaurant(
-- id INT PRIMARY KEY,
-- area VARCHAR(255),
-- city VARCHAR(255),
-- restaurant VARCHAR(255),
-- price DECIMAL(10, 2),
-- avg_ratings DECIMAL(3, 1),
-- total_ratings INT,
-- food_type VARCHAR(255),
-- address VARCHAR(255),
-- delivery_time INT
-- );

-- EDA
-- GENERIC QUESTIONS

-- How many records (restaurants) are in the dataset?
select count(distinct restaurant)as total_restaurant from restaurant;

-- What are the unique areas in the dataset?
select distinct area from restaurant

-- How many restaurants are there in each city?
select city,count(*)as restaurants from restaurant
group by 1
order by restaurants desc

-- What is the average price range of restaurants in each city?
select city,avg(price)as price_range from  restaurant
group by 1
order by price_range desc

-- What is the most expensive restaurant in each city?
select city,restaurant,expensive_restaurant from 
(select city,restaurant,max(price)as expensive_restaurant,rank() over(partition by city order by max(price) desc) as rnk from restaurant
group by 1,2) restaurant
where rnk = 1

-- What is the average rating of restaurants in each city?
select city,round(avg(avg_ratings),1) from restaurant
group by 1

-- How many restaurants offer specific food types (e.g., Chinese, North Indian) in each city?
select city,food_type,count(restaurant)no_of_restaurants from restaurant
group by 1,2
order by count(restaurant)desc,city

-- Which restaurant has the highest total ratings in each city?
select city,restaurant,total_ratings from 
(select city,restaurant,max(total_ratings)as total_ratings,rank() over(partition by city order by max(total_ratings) desc) as rnk from restaurant
group by 1,2) restaurants
where rnk = 1

-- What is the distribution of restaurant prices in each city (e.g., count of restaurants in different price ranges)?
select city,price,
case when price between 0 and 300 then 'Lowest Range'
when price between 301 and 1000 then 'Mid Range'
else 'High Range'
end as price_range, 
count(*) from restaurant
group by 1,2

-- What is the distribution of restaurant ratings in each city (e.g., count of restaurants with different rating ranges)?
select city,avg_ratings,count(*)as no_of_restaurants from restaurant
group by 1,2

-- What is the average delivery time for restaurants in each area?
select area,avg(delivery_time) from restaurant
group by 1

-- list top-rated restaurants based on customer reviews
select restaurant,avg_ratings from restaurant
order by avg_ratings desc;

-- What are the top 10 most expensive restaurants in the dataset
select restaurant,price from restaurant
order by price desc
limit 10;

-- INTERMEDIATE QUESTIONS

-- How many restaurants are there in each area of Bangalore?
select area,count(*)as no_of_restaurants from restaurant
where city = 'Bangalore'
group by 1
order by no_of_restaurants desc

-- What are the different food types offered by restaurants in Hyderabad?
select food_type,count(*)as no_of_restaurant_offers from restaurant
where city = 'Hyderabad'
group by 1
order by count(*) desc

-- Which restaurant offers the highest number of food types?
select restaurant,count(distinct food_type)as num_food_types from restaurant
group by 1
order by count(distinct food_type) desc

-- select restaurant,food_type from restaurant
-- where restaurant = 'lassi shop'

-- How many restaurants have a rating above 4.0 in Bangalore?
select count(*) from restaurant
where avg_ratings > 4.0 and city = 'Bangalore'

-- What is the average price of restaurants that offer "Biryani" in Hyderabad?
select restaurant,avg(price) from restaurant
where city = 'Hyderabad' and food_type like '%Biryani%'
group by 1

-- How many restaurants have "Desserts" as one of their food types in Bangalore?
select count(*) from restaurant
where city = 'Bangalore' and food_type like '%Dessert%'

-- What is the distribution of total ratings in Bangalore?
select total_ratings,count(*) as count from restaurant
where city = 'Bangalore'
group by 1

-- How many restaurants offer cuisine types that include "Mughlai" in Kolkata?
select count(*) as NumOfRestaurants from restaurant
where city = 'Kolkata' and food_type like '%Mughlai%'

-- Which area has the highest average restaurant price in Bangalore?
select area,price from restaurant
where price > (select avg(price) from restaurant
where city = 'Bangalore')
and city = 'Bangalore'

-- How many restaurants offer "Mughlai" and have a rating above 4.0 in Hyderabad
select count(*) as NumOfRestaurants from restaurant
where city = 'Hyderabad' and food_type like '%Mughlai%' and avg_ratings > 4.0

-- ADVANCE QUESTION

-- What is the average number of total ratings for restaurants in each city?
select city,avg(total_ratings) from restaurant
group by 1

-- How many restaurants in Bangalore offer both "Chinese" and "North Indian" cuisines?
select count(*) from restaurant
where city = 'Bangalore' and food_type like '%Chinese%' and food_type like '%North Indian%'

-- Which city has the highest average price for restaurants?
select city,avg(price) from restaurant
group by 1
order by avg(price) desc limit 1

-- What is the distribution of delivery times for restaurants in Hyderabad?
select delivery_time,count(*) RestaurantCount from restaurant
where city = 'Hyderabad'
group by 1

-- How many restaurants in each city have a rating of 4.0 or above and offer "Biryani"?
select city,count(*) as RestaurantCount from restaurant
where avg_ratings >= 4.0 and food_type like '%Biryani%'
group by 1

-- What is the most common food type offered by restaurants in each area of Bangalore?
select area,food_type,count(*)as foodCount from restaurant
where city = 'Bangalore'
group by 1,2
order by foodCount desc

-- Which restaurant offers the highest number of food types across all cities?
select city,count(distinct food_type)as highFoodType from restaurant
group by 1
order by highFoodType desc limit 1

-- What is the average number of food types offered by restaurants in each city?
select city,avg(foodcount) as avg_num_food from 
(select city,count(food_type)as foodcount from restaurant
group by 1) restaurant
group by 1

-- How many restaurants have a delivery time of less than 45 minutes in each area of Pune?
select area,delivery_time from restaurant
where city = 'Pune' and delivery_time < 45
group by 1,2

-- What is the distribution of restaurant prices for restaurants with a rating above 4.0 in Kolkata?
select price,count(*)as restaurantCount from restaurant
where city = 'Kolkata' and avg_ratings > 4.0
group by 1
order by restaurantCount desc

-- What are the top 10 areas with the highest average price for restaurants in a specific city (e.g., Mumbai)?
select area,avg(price) from restaurant
where city = 'Mumbai'
group by 1
order by avg(price) desc
limit 10;

-- which food type has the highest average rating across all cities
select city,food_type, avg(avg_ratings) from restaurant
group by 1,2
order by city,avg(avg_ratings) desc;

-- What is the most popular type of food in each city based on the number of restaurants offering it
select city,food_type from 
(select city,food_type,count,rank() over(partition by city order by count desc) as rnk from
(select city,food_type,count(*)as count from restaurant
group by 1,2
order by city,count desc) restaurant) restaurant
where rnk =1 ;