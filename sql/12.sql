/*
 * List the title of all movies that have both the 'Behind the Scenes' and the 'Trailers' special_feature
 *
 * HINT:
 * Create a select statement that lists the titles of all tables with the 'Behind the Scenes' special_feature.
 * Create a select statement that lists the titles of all tables with the 'Trailers' special_feature.
 * Inner join the queries above.
 */

SELECT bts.title
FROM (
    SELECT title, film_id
    FROM film
    WHERE 'Behind the Scenes' = ANY(special_features)
) bts
INNER JOIN (
    SELECT title, film_id
    FROM film
    WHERE 'Trailers' = ANY(special_features)
) trail ON bts.film_id = trail.film_id
ORDER BY bts.title;
