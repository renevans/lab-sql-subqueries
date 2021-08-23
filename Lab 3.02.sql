USE sakila;

-- 1.  How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(inventory_id) as Number_of_copies
FROM inventory
WHERE film_id in(
SELECT film_id 
FROM film
WHERE title = 'Hunchback Impossible');

-- 2.  List all films whose length is longer than the average of all the films.
SELECT film_id, title, length 
FROM film
WHERE length > (
SELECT avg(length) from film);

-- 3.  Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name from actor 
WHERE actor_id in ( 
SELECT actor_id from film_actor
WHERE film_id = (
SELECT film_id 
FROM film 
WHERE title = 'Alone Trip'));

-- 4.  Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT film_id, title from film 
where film_id in (
SELECT film_id FROM film_category
WHERE category_id = (
SELECT category_id FROM category
WHERE name = 'Family'));

-- 5.  Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email from customer
WHERE address_id in 
(SELECT address_id from address 
where city_id in (
SELECT city_id from city
where country_id in (
SELECT country_id from country
where country = 'Canada')));

SELECT first_name, last_name, email from customer
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id)
WHERE country = 'Canada';

-- 6.  Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- V1: 
SELECT title from film
WHERE film_id in (
SELECT film_id from film_actor
where actor_id = (
SELECT actor_id from 
(SELECT actor_id, count(film_id) FROM film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
limit 1) sub1));

-- V2:
SELECT title from film
WHERE film_id in (
SELECT film_id from film_actor
where actor_id = 
(SELECT actor_id FROM film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
limit 1));

-- 7.  Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title as Films_rented from film
WHERE film_id in (
(SELECT film_id from inventory
WHERE inventory_id in (
(SELECT inventory_id from rental 
where customer_id = 
(SELECT customer_id from payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
limit 1)))));

-- 8.  Customers who spent more than the average payments.

SELECT first_name, last_name
FROM customer 
WHERE customer_id in
(SELECT customer_id from payment
GROUP BY customer_id
HAVING sum(amount) > (
SELECT avg(amount) from payment));
