SELECT *
FROM distributors;

SELECT *
FROM rating;

SELECT *
FROM revenue;

SELECT *
FROM specs;

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT film_title AS name, 
	release_year,
	MIN(worldwide_gross) AS ww_gross
FROM specs
LEFT JOIN revenue
USING (movie_id)
GROUP BY (film_title, release_year)
ORDER BY ww_gross;

--Answer: Semi-Tough, 1977, $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT release_year, AVG(imdb_rating) AS avg_imdb_rtng
FROM specs
LEFT JOIN rating
USING (movie_id)
GROUP BY release_year
ORDER BY avg_imdb_rtng DESC;

--Answer: 1991 has the highest average IMDB rating. 1991 IMDB Average Rating = 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT film_title,
	MAX(worldwide_gross) as max_ww_gross
FROM specs
LEFT JOIN revenue
USING (movie_id)
WHERE mpaa_rating='G'
GROUP BY film_title
ORDER BY max_ww_gross DESC;
--First Run at 3

SELECT film_title,
	company_name,
	MAX(worldwide_gross) as max_ww_gross
FROM specs
LEFT JOIN revenue
ON specs.movie_id=revenue.movie_id
LEFT JOIN distributors
ON specs.domestic_distributor_id=distributor_id
WHERE mpaa_rating='G'
GROUP BY (film_title, company_name)
ORDER BY max_ww_gross DESC
LIMIT 1;

--ANSWER: Toy Story 4, Walt Disney, WW Gross = 1,073,394,593

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

-- 5. Write a query that returns the five distributors with the highest average movie budget.

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?