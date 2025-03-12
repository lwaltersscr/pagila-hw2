/*
 * Select the titles of all films that the customer with customer_id=1 has rented more than 1 time.
 *
 * HINT:
 * It's possible to solve this problem both with and without subqueries.
 */

SELECT title
FROM film
WHERE film_id IN (
    SELECT inventory.film_id
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    WHERE rental.customer_id = 1
    GROUP BY inventory.film_id
    HAVING COUNT(rental.rental_id) > 1)
