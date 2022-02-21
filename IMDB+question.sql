

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

USE imdb;

SELECT 'director_mapping' table_name, COUNT(*) row_count
FROM director_mapping
UNION
SELECT 'genre' table_name, COUNT(*) row_count
FROM genre
UNION
SELECT 'movie' table_name, COUNT(*) row_count
FROM movie
UNION
SELECT 'names' table_name, COUNT(*) row_count
FROM names
UNION
SELECT 'ratings' table_name, COUNT(*) row_count
FROM ratings
UNION
SELECT 'role_mapping' table_name, COUNT(*) row_count
FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	COUNT(*)-COUNT(id) AS id_nulls, 
    COUNT(*)-COUNT(title) as title_nulls, 
    COUNT(*)-COUNT(year) AS year_nulls, 
    COUNT(*)-COUNT(date_published) AS date_published_nulls, 
    COUNT(*)-COUNT(duration) AS duration_nulls, 
    COUNT(*)-COUNT(country) AS country_nulls, 
    COUNT(*)-COUNT(worlwide_gross_income) AS worlwide_gross_income_nulls, 
	COUNT(*)-COUNT(languages) AS languages_nulls, 
    COUNT(*)-COUNT(production_company) AS production_company_nulls
FROM 
	movie;    


/*
-- So below are the columns for which non-null row count is less than total count of movie table
1. country
2. worlwide_gross_income
3. languages
4. production_company
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies per year
SELECT 
	YEAR(date_published) AS Years, COUNT(id) AS number_of_movies
FROM movie
GROUP BY Years;

-- Number of movies per month
SELECT 
	MONTH(date_published) AS month_num, COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 'INDIA' country_name, COUNT(id) as movies_count
FROM movie
WHERE year = 2019 and country regexp 'India'
UNION
SELECT 'USA' country_name, COUNT(id) as movies_count
FROM movie
WHERE year = 2019 and country regexp 'USA'
UNION
SELECT 'INDIA or USA' country_name, COUNT(id) as movies_count
FROM movie
WHERE year = 2019 and country regexp 'USA|INDIA';
-- **Total of 1059 movies were produced in the USA or India in the year 2019**


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre
ORDER BY genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- for all three years
SELECT 
	genre, 
    COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count desc
limit 1;
-- **Drama had the highest number of movies produced overall**

-- for last year (2019)
SELECT 
	genre, 
    COUNT(movie_id) AS movie_count
FROM 
	genre g 
    JOIN movie m 
    ON g.movie_id = m.id 
WHERE year = '2019'
GROUP BY genre
ORDER BY movie_count desc
limit 1;
-- **Drama had the highest number of movies produced for last year**


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre AS
(
SELECT movie_id, COUNT(genre)
FROM genre
GROUP BY movie_id
HAVING COUNT(genre) = 1
)
SELECT COUNT(movie_id) as movie_count_with_1_genre
FROM movies_with_one_genre;
-- **There are 3289 movies with only one genre**


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre, 
    ROUND(AVG(duration), 2) as avg_duration
FROM 
	movie m 
    JOIN genre g 
    ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	genre, 
    COUNT(movie_id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(movie_id) DESC) as genre_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(movie_id) DESC) as genre_ROW_rank
FROM 
	movie m
    JOIN genre g
    ON m.id = g.movie_id
GROUP BY genre;
-- **Thriller movie has a rank = 3**


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	MIN(avg_rating) min_avg_rating,
    MAX(avg_rating) max_avg_rating,
    MIN(total_votes) min_total_votes,
    MAX(total_votes) max_total_votes,
    MIN(median_rating) min_median_rating,
    MAX(median_rating) max_median_rating
FROM ratings;

 
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rank_info AS 
(
SELECT 
	title,
    avg_rating,
    DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings r 
	JOIN movie m
    ON r.movie_id = m.id
)    
SELECT *
FROM rank_info
WHERE movie_rank < 10;
    
    
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	median_rating,
    COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;
-- **Maximum movies have median rating = 7**


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_rank AS
(
SELECT 
	production_company,
    COUNT(movie_id),
    DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_company_rank
FROM ratings r
	JOIN movie m
    ON r.movie_id = m.id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company
)
SELECT *
FROM prod_rank
WHERE prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre,
    COUNT(g.movie_id) as movie_count
FROM genre g
	JOIN ratings r
    ON g.movie_id = r.movie_id
    JOIN movie m
    ON g.movie_id = m.id
WHERE year = 2017 AND MONTH(date_published) = 3  AND total_votes > 1000 AND country REGEXP 'USA'
GROUP BY genre
ORDER BY movie_count DESC; 


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	m.title,
    r.avg_rating,
    g.genre
FROM 	
	movie m
    JOIN ratings r 
    ON m.id = r.movie_id
    JOIN genre g
    ON m.id = g.movie_id
WHERE avg_rating > 8 AND title REGEXP '^The'
ORDER BY g.genre, avg_rating;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	median_rating,
    COUNT(movie_id)
FROM 
	movie m
    JOIN ratings r
    ON m.id = r.movie_id
WHERE 
	median_rating = 8 
    AND 
    date_published BETWEEN  '2018-04-01' AND '2019-04-01';
-- **361 movies given median rating of 8 release between 1 April 2018 and 1 April 2019**


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH german_votes AS
(
SELECT 
	languages,
    SUM(total_votes) as total_votes_german
FROM 
	movie m 
    JOIN ratings r
    ON m.id = r.movie_id
WHERE languages REGEXP 'German'
),
italian_votes AS
(
SELECT 
	languages,
    SUM(total_votes) AS total_votes_italian
FROM 
	movie m 
    JOIN ratings r
    ON m.id = r.movie_id
WHERE languages REGEXP 'italian'
)
SELECT 
	CASE 
		WHEN g.total_votes_german > i.total_votes_italian THEN 'YES, German movies get more votes than italian'
        ELSE 'NO, German movies do not get more votes than italian'
	END AS 'Result'
FROM 
	german_votes g, 
    italian_votes i;
    
-- **Yes, German movies get more votes than Italian movies**


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	COUNT(*) - COUNT(id) as id_nulls,
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;
	
    
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS
(
SELECT 
	genre,
	COUNT(g.movie_id) as movie_counts
FROM 
	genre g
    JOIN 
    ratings r
    ON g.movie_id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY movie_counts DESC
LIMIT 3
),
director AS
(
SELECT 
	n.name AS director_name,
    COUNT(g.movie_id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) director_rank,
    ROW_NUMBER() OVER(ORDER BY COUNT(g.movie_id) DESC) director_rank_row
FROM 
	names n
    JOIN director_mapping d
    ON n.id = d.name_id
    JOIN genre g
    ON d.movie_id = g.movie_id
    JOIN ratings r
    ON r.movie_id = g.movie_id,
   top_3_genre
WHERE g.genre IN (top_3_genre.genre) AND avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
)
SELECT *
FROM director
WHERE director_rank <=3;
-- James Mangold no doubt has given highest number of hit movies, while there is a clash for 2nd and 3rd position for other directors.


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	name AS actor_name,
    COUNT(r.movie_id) AS movie_count
FROM 
	names n
    JOIN role_mapping rm
    ON n.id = rm.name_id
    JOIN ratings r
    ON rm.movie_id = r.movie_id
WHERE median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;
-- Mammootty and Mohanlal are the top 2 actors whose movies have a median rating >= 8

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_3_prod_comp AS
(
SELECT 
	production_company,
    SUM(total_votes) AS vote_count,
    DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
	movie m
    JOIN ratings r
    ON m.id = r.movie_id
 GROUP BY production_company   
)
SELECT *
FROM top_3_prod_comp 
WHERE prod_comp_rank <= 3;
-- **Marvel studios, Twentieth century fox and Warner bros. are the top 3 production houses**


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating*total_votes)/SUM(total_votes),2) AS actors_avg_rating,
	ROW_NUMBER() OVER(ORDER BY ROUND(SUM(r.avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actors_rank
FROM 
	names n
    JOIN role_mapping rm
    ON n.id = rm.name_id
    JOIN ratings r
	ON rm.movie_id = r.movie_id
    JOIN movie m
    ON m.id = r.movie_id
WHERE country REGEXP 'INDIA' AND category = 'actor'
GROUP BY actor_name
HAVING COUNT(r.movie_id)>=5;
-- Top actor is Vijay Sethupathi


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actresses AS
(
SELECT
	name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank
FROM 
	names n
    JOIN role_mapping rm
    ON n.id = rm.name_id
    JOIN ratings r
	ON rm.movie_id = r.movie_id
    JOIN movie m
    ON m.id = r.movie_id
WHERE country REGEXP 'INDIA' AND rm.category = 'actress' AND languages REGEXP 'hindi'
GROUP BY actress_name
HAVING COUNT(r.movie_id)>=3
)
SELECT *
FROM top_actresses
WHERE actress_rank <=5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT
	genre,
    title,
    avg_rating,
	CASE 
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		ELSE 'Flop movies'
	END AS 'movie_status'
FROM 
	genre g
	JOIN movie m
    ON g.movie_id = m.id
    JOIN ratings r
    ON g.movie_id = r.movie_id
WHERE genre = 'Thriller'
ORDER BY avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH summary AS
(
SELECT
	genre,
    AVG(duration) AS avg_duration,
    SUM(AVG(duration)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(AVG(duration)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration 
FROM 
	genre g
    JOIN movie m
    ON g.movie_id = m.id
GROUP BY genre
)
SELECT 
	genre,
    ROUND(avg_duration,2) AS avg_duration,
    ROUND(running_total_duration,2) AS running_total_duration,
    ROUND(moving_avg_duration, 2) AS moving_avg_duration
FROM summary;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies




WITH gross_income_int AS
(
SELECT 
	id,
    cast(TRIM(LEADING '$' FROM worlwide_gross_income) as UNSIGNED) AS converted_gross_income
from movie
),

top_3_genre AS
(
SELECT 
	genre,
    COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),

FINAL AS
(
SELECT 
	g.genre,
	year,
    title AS movie_name,
    worlwide_gross_income AS worldwide_gross_income,
    DENSE_RANK() OVER(PARTITION BY YEAR ORDER BY gi.converted_gross_income DESC) AS movie_rank
FROM 
	movie m 
    JOIN genre g
    ON m.id = g.movie_id
    JOIN gross_income_int gi
    ON gi.id = m.id,
    top_3_genre
WHERE g.genre in (top_3_genre.genre)
)
SELECT *
FROM final
WHERE movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company,
    COUNT(id) as movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank 
FROM 
	movie m
    JOIN ratings r
    ON m.id = r.movie_id
WHERE median_rating >=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;
-- Star cinema and Twentieth century fox are the top two production houses


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_rank AS
(
SELECT
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
	RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank,
    DENSE_RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank_dense,
    ROW_NUMBER() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank_row
FROM 
	names n
    JOIN role_mapping rm
    ON n.id = rm.name_id
    JOIN ratings r
    ON r.movie_id = rm.movie_id
    JOIN movie
    ON movie.id = r.movie_id
    JOIN genre g
    ON g.movie_id = r.movie_id
WHERE avg_rating > 8 AND genre = 'Drama' AND category = 'actress'
GROUP BY actress_name
)

SELECT *
FROM actress_rank
WHERE actress_rank <=3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH date_info AS
(
SELECT
	d.name_id,
    name, 
    d.movie_id,
    m.date_published,
    LEAD(date_published , 1) OVER (PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM 
	director_mapping d JOIN names n ON d.name_id = n.id
    JOIN movie m ON d.movie_id = m.id
),

date_diff AS
(
SELECT *,
	DATEDIFF(next_movie_date, date_published) AS diff
FROM date_info
),

avg_inter_days AS
(
SELECT name_id, AVG(diff) as avg_inter_movie_days
FROM date_diff
GROUP BY name_id
)

SELECT 
	d.name_id AS director_id,
    name AS director_name,
    COUNT(d.movie_id) AS number_of_movies,
    ROUND(avg_inter_movie_days) AS inter_movie_days,
    ROUND(sum(avg_rating*total_votes)/sum(total_votes), 2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration
FROM 
	names n JOIN director_mapping d ON n.id = d.name_id
    JOIN ratings r ON d.movie_id = r.movie_id
    JOIN movie m ON m.id = r.movie_id 
    JOIN avg_inter_days a ON a.name_id = d.name_id
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;

