/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */

WITH film_revenue AS (
    SELECT
        f.film_id,
        f.title,
        COALESCE(SUM(p.amount), 0)::numeric(8,2) AS revenue
    FROM
        film f
        LEFT JOIN inventory i ON f.film_id = i.film_id
        LEFT JOIN rental r ON i.inventory_id = r.inventory_id
        LEFT JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY
        f.film_id, f.title
),
ranked_revenue AS (
    SELECT
        RANK() OVER (ORDER BY revenue DESC) AS rank,
        title,
        revenue,
        DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rank
    FROM film_revenue
),
cumulative_revenue AS (
    SELECT
        rank,
        title,
        revenue,
        SUM(revenue) OVER (ORDER BY dense_rank RANGE UNBOUNDED PRECEDING) AS "total revenue"
    FROM ranked_revenue
),
total_sum AS (
    SELECT SUM(revenue) AS total_revenue FROM film_revenue
)
SELECT
    cr.rank,
    cr.title,
    cr.revenue,
    cr."total revenue",
    CASE
        WHEN 100 * cr."total revenue" / (SELECT total_revenue FROM total_sum) >= 100
        THEN '100.00'
        ELSE TO_CHAR(
            100 * cr."total revenue" / (SELECT total_revenue FROM total_sum),
            'FM00.00'
        )
    END AS "percent revenue"
FROM cumulative_revenue cr
ORDER BY cr.revenue DESC, cr.title ASC;
