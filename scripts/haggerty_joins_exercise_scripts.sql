--Reviewing the Tables

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
ORDER BY ww_gross
LIMIT 1;

--Answer: Semi-Tough, 1977, $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT release_year, AVG(imdb_rating) AS avg_imdb_rtng
FROM specs
LEFT JOIN rating
USING (movie_id)
GROUP BY release_year
ORDER BY avg_imdb_rtng DESC
LIMIT 1;

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

--Tried this problem 2 ways FULL and Left Join. FULL JOIN returns 24 Lines w/ 1 NULL for Company Name. (FULL JOIN combines both LEFT & RIGHT JOINS) Left Join Returns 23 Lines w/no NULL for Company. (LEFT JOIN Returns Everything from Left Table and Records from Right Table that Match on the Joining Field Created in ON Statement.)

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

--ANSWER: 2 Movies are Distributed by a Non-CA Company. Of the 2 Movies, Dirty Dancing has the Highest IMDB Rating (7.0). 
--Based on Review of the Tables, this is a Correct Answer, But, Adding film title and imdb rating negates the count for film_title....This would lead to an incorrect answer in a slightly different situation.....Will continue to troubleshoot and clean this up. 

-- SECOND ATTEMPT 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT film_title, imdb_rating 
FROM distributors
INNER JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)
WHERE headquarters NOT LIKE ('%CA%')
GROUP BY film_title, imdb_rating
ORDER BY imdb_rating DESC;

--ANSWER SECOND ATTEMPT 6: --ANSWER: 2 Movies are Distributed by a Non-CA Company. Of the 2 Movies, Dirty Dancing has the Highest IMDB Rating (7.0).
--Based on the Limited Dataset and Returns for Movies Distributed by a Non-CA Company, Executing a Count was not required. Removing the Count Produced a Cleaner Query for the Question. 

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


-- PURE GOOGLE BONUS - These should be things you've never seen before.

-- 1.	Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. This should result in a table with just one row.

SELECT SUM(worldwide_gross) AS sum_ww_gross, 
	ROUND(AVG(imdb_rating), 2) AS avg_imdb_rtng,
	release_year
FROM specs
LEFT JOIN revenue
USING (movie_id)
LEFT JOIN rating
USING (movie_id)
GROUP BY release_year
ORDER BY release_year;

