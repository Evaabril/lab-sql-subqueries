USE sakila;

-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(*) AS number_of_copies
FROM film
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT film_id, title, length
FROM film
WHERE length >(
	SELECT
	AVG (length)
    FROM film
    );
    
    
-- 3. Use a subquery to display all actors who appear in the film "Alone Trip". 

SELECT actor.actor_id, actor.first_name,  actor.last_name
FROM actor
WHERE actor.actor_id IN (
        SELECT film_actor.actor_id
        FROM film_actor
        INNER JOIN film ON film_actor.film_id = film.film_id
        WHERE film.title = 'Alone Trip'
    );




-- **Bonus**:

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films. 

SELECT film.film_id, film.title
FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE UPPER(co.country) = 'CANADA';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
) AS most_prolific_actor ON fa.actor_id = most_prolific_actor.actor_id;

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN (
    SELECT customer_id
    FROM (
        SELECT customer_id, SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
        ORDER BY total_amount_spent DESC
        LIMIT 1
    ) AS most_profitable_customer
) AS mp_customer ON r.customer_id = mp_customer.customer_id;




-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount_spent) FROM (SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment GROUP BY customer_id) AS avg_amount);
