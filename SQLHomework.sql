#use sakila database
use sakila;

#1a. display first and last name of all actors
select first_name, last_name from actor;

#1b. display first and last name in single column called Actor Name
select concat_ws(" ", first_name, last_name) as 'Actor Name' from actor;

#2a. display ID, first and last name of actor named "Joe"
select actor_id, first_name, last_name from actor where first_name = "JOE";

#2b. display all actors whose last name contains "GEN"
select * from actor where last_name like '%GEN%';

#2c. display all actors whose last name contains "LI", then ordered by last name and fist name
select * from actor where last_name like '%LI%' order by last_name, first_name;

#2d. display country id and country for list of countries
select country_id, country from country where country in ("Afghanistan", "Bangladesh", "China");

#3a. create a column "description" in table actor and use data type 'BLOB'
alter table actor add column description blob;

#3b. delete colum "description" from table actor
alter table actor drop column description;

#4a. list last name of actors and how many actor with that last name
select last_name, count(*) as count_of_actors 
from actor 
group by last_name;

#4b. list last name of actors and how many actors with that last name that are shared by at least two actors
select last_name, count(*) as count_of_actors 
from actor 
group by last_name
having count_of_actors >=2;

#4c. change "GROUCHO WILLIAMS" to "HARPO WILLIAMS"
update actor
set first_name = "HARPO"
where (first_name = "GROUCHO" and last_name = "	WILLIAMS");

select * from actor where first_name = "GROUCHO";

set SQL_SAFE_UPDATES = 0;
update actor
set first_name = "GROUCHO"
where first_name = "HARPO";

#4d. change "HARPO" TO "GROUCHO"
replace into actor(first_name)
select first_name from actor
where first_name = "HARPO";

#5a. display schema of "address" table
show create table address;

#6a. use join, display first_name, last_name, address of each staff member from tables "staff" and "address" 
select first_name, last_name, address 
from staff
left join address using(address_id);

#6b. use join, display the total amount by each staff member in august of 2005 from tables "staff" and "payment"
select first_name, last_name, sum(amount)
from staff
join payment using (staff_id)
where payment_date between "2005-08-01" and "2005-08-31"
group by staff_id;

#6c.inner join to list film and number of actors from table "film_actor" and "film"
select title, count(*) as number_of_actors
from film
inner join film_actor using (film_id)
group by title;

#6d. number of copies film "Hunchback Impossible" in the inventory
select title, count(*) as number_of_copies
from inventory
join film using (film_id)
where title = "HUNCHBACK IMPOSSIBLE";

#6e. join table "payment" and "customer" to list the total paid by each customer in alphabetical order by last name
select last_name, first_name, sum(amount) as total_amount_paid
from customer
join payment using(customer_id)
group by customer_id
order by last_name, first_name;

#7a. use subquery to display titles starting with the letters "K" and "Q" whose language is English
select title from film
join language using (language_id)
where name = "English"
and title in
(select title from film where (title like "K%" or title like "Q%"));

#7b. use subquery to display all actors in film "Alone Trip"
select first_name, last_name
from film_actor
join film using (film_id)
join actor using (actor_id)
where title = "ALONE TRIP";

SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));

#7c. use join to list name and email addresses of all Canadian customer 
select first_name, last_name, email
from customer
join address using (address_id)
join city using (city_id)
join country using (country_id)
where country = "Canada";

#7d. list family film category
select title, description, rating
from film_list
where category = "Family";

#7e. display the most frequently rented movies in descending order
select title, count(*) rental_count
from film
join inventory using (film_id)
join rental using (inventory_id)
group by (film_id)
order by rental_count desc;

#7f. display how much business, in dollars, each store brought in
SELECT  s.store_id, SUM(amount) AS business_in_dollars
from store s
inner join staff st 
ON s.store_id = st.store_id
inner join payment p
on p.staff_id = st.staff_id 
group by s.store_id
order by business_in_dollars ASC;

#7g. display each store its store ID, city, and country
# checking store
select * from store;

select store_id, city, country
from store
join address using (address_id)
join city using (city_id)
join country using (country_id);

#7h. list top five genres in gross revenue in desc order
select name as top_five_genres, sum(amount) as gross_revenue
from category 
inner join film_category using (category_id)
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
group by top_five_genres
order by gross_revenue  
limit 5;

#8a. create view for top five genres in gross revenue in desc order
drop view if exists top_five_grossing_genres;

create view top_five_grossing_genres as

select name as top_five_genres, sum(amount) as gross_revenue
from category 
inner join film_category using (category_id)
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
group by top_five_genres
order by gross_revenue  
limit 5;

#8b. display the view just created
select * from top_five_grossing_genres;

#8c. delete the view just created
drop view top_five_grossing_genres;