# IMDB_Movies_Analysis

* Input file - IMDb+movies+Data+and+ERD+final.xlsx
* Load above data in SQL using SQL script 'IMDB+dataset+import.sql'
* For all the analysis, run queries from 'IMDB+question.sql'

## Problem Statement -
RSVP movies wants to release movie in 2022 for global audience and for that they want to see the behaviour of various factors related to movies based on IMDB data.
It will help them to consider parameters(genre, director, duration, etc.) for their upcoming movie.

## Insights from data and recommendation to RSVP movies  :
1)	Year-wise and month-wise trend for movies:
Based on analysis, number of movies released follows downward trend from year 2017 to 2019, while most of the movies were released in march specially in genre – Drama. 
Also USA and India are the top movie producing countries with more than 1000 movies in year 2019.
Highest grossing movies per year in top 3 genres (Drama, Comedy, Thriller)
2017- The fate of furious (Thriller)
2018- Bohemian Rhapsody (Drama)
2019- Avengers end game (Drama)

2)	Genre to target on and duration of movies to keep:
RSVP should target genre Drama which is having highest count of movies and has average movie duration of 106.77 mins.
Also count of movies is high for Comedy and Thriller genre, while highest average duration is for Action movies with 112.88 mins.
Running total duration and moving avg. duration will help to understand trend for movie duration across genre.

3)	Average and median rating:
Kirket and Love in kilnerry tops with avg. rating with 10, while most of the movies received median rating of 7.

4)	Production houses to partner with:
Dream Warrior Pictures or National Theatre Live – Produced highest number of super-hit movies(avg. rating > 8) 
Marvel studios, Twentieth century fox and Warner bros. - Produced movies with highest number of votes.
Star cinema and Twentieth century fox – Produced highest number of hits (median rating >=8, multilingual category)

5)	Languages to consider:
German movies get more votes than Italian. Overall English movies rule the world.

6)	Top Director, Actor, Actress:
James Mangold - Directed highest number of hit movies(average rating > 8) in top 3 genre Drama, Action, Comedy
Andrew Jones and A.L. Vijay - Directed most number of movies
Vijay Sethupathi and Tapsee Pannu - Top actors/actresses in India based on average ratings 
Mammoty, Mohanlal- Top actors based on movies with (median rating >= 8)
Parvathy Thiruvothu, Susan Brown, Amanda Lawrence -  Top actresses in drama genre(median rating > 8)

