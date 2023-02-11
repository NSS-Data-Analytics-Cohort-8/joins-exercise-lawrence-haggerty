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

SELECT company_name,
	COUNT(film_title) AS film_count
FROM distributors
FULL JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
GROUP BY company_name
ORDER BY film_count DESC;

SELECT company_name,
	COUNT(film_title) AS film_count
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
GROUP BY company_name
ORDER BY film_count DESC;

SELECT company_name, COUNT(film_title) AS film_title
FROM distributors
FULL JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id 
GROUP BY company_name
ORDER BY film_title DESC;


--Tried this problem 2 ways FULL and Left Join. FULL JOIN returns 24 Lines w/ 1 NULL for Company Name. Left Join Returns 23 Lines w/no NULL for Company.

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT company_name,
	ROUND(AVG(film_budget)) AS avg_film_budget
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
LEFT JOIN revenue
USING (movie_id)
WHERE film_budget IS NOT NULL
GROUP BY company_name
ORDER BY avg_film_budget DESC
LIMIT 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT company_name, 
	film_title,
	imdb_rating,
	COUNT (film_title) AS film_title_count
FROM distributors
INNER JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)
WHERE headquarters NOT LIKE ('%CA%')
GROUP BY company_name, film_title, imdb_rating
ORDER BY imdb_rating DESC;

--ANSWER: 2 Movies are Distributed by a Non-CA Company. Of the 2 Movies, Dirty Dancing has the Highest IMDB Rating (7.0). Adding film title and imdb rating negates the count for film_title. I observed this as I built out the query....Will continue to troubleshoot and clean this up. 

-- SECOND ATTEMPT 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT company_name, 
	COUNT (film_title) AS film_title_count,
	(SELECT movie_title,imdb_rating
	FROM specs
	USING movie_id)
FROM distributors
INNER JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)
WHERE headquarters NOT LIKE ('%CA%')
GROUP BY company_name;

SELECT movie_title, imdb_rating
FROM distributor
INNER JOIN spec
ON distributors.distributor_id=specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT ROUND(AVG(imdb_rating), 2) AS avg_imdb_rating
FROM specs
LEFT JOIN rating
USING (movie_id)
WHERE length_in_min>120;
--Return 7.26 Average IMDB Rating

SELECT ROUND(AVG(imdb_rating), 2) AS avg_imdb_rating
FROM specs
LEFT JOIN rating
USING (movie_id)
WHERE length_in_min<120;
--Return 6.92

--Combine Using Subquery in SELECT Clause
SELECT ROUND(AVG(imdb_rating), 2) AS avg_imdb_ovr2hr,
	(SELECT ROUND(AVG(imdb_rating), 2) 
	FROM specs
	LEFT JOIN rating
	USING (movie_id)
	WHERE length_in_min<120) AS avg_imdb_undr2hr
FROM specs
LEFT JOIN rating
USING (movie_id)
WHERE length_in_min>120;

--ANSWER: Movies Over 2 Hours Have a Higher IMDB Average (7.26 vs 6.92)
