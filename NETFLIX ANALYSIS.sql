CREATE DATABASE NETFLIX;
USE NETFLIX;

SELECT * FROM TITLES;
SELECT * FROM CREDITS;

-- What were the top 10 movies according to IMDB score?

SELECT TOP 10 title,type, imdb_score
FROM titles
WHERE imdb_score >= 8.0 AND type = 'MOVIE'
ORDER BY imdb_score DESC

-- What were the top 10 shows according to IMDB score? 

SELECT TOP 10 title, type, imdb_score
FROM titles
WHERE imdb_score >= 8.0
AND type = 'SHOW'
ORDER BY imdb_score DESC

-- What were the average IMDB and TMDB scores for shows and movies? 
SELECT DISTINCT type,ROUND(AVG(imdb_score),2) AS avg_imdb_score, ROUND(AVG(tmdb_score),2) as avg_tmdb_score
FROM titles
GROUP BY type ;

-- What were the average IMDB and TMDB scores for each age certification for shows and movies?
select distinct age_certification , round(avg(imdb_score),2) as avg_imbd_score ,
round(avg(tmdb_score),2) as avg_tmbd_score from titles
group by age_certification
ORDER BY avg_imbd_score DESC

-- What were the average IMDB and TMDB scores for each production country?
SELECT DISTINCT production_countries,ROUND(AVG(imdb_score),2) AS avg_imdb_score,ROUND(AVG(tmdb_score),2) AS avg_tmdb_score
FROM titles
GROUP BY production_countries
ORDER BY avg_imdb_score DESC



-- Which genres had the most shows? 

ALTER TABLE TITLES 
ALTER COLUMN GENRES NVARCHAR(300)

SELECT TOP 5 GENRES , title_count FROM(
SELECT TYPE,genres, COUNT(*) AS title_count
FROM titles 
GROUP BY genres,TYPE
) AS X
WHERE type = 'Show'
ORDER BY title_count DESC

--OR 

-- Which genres had the most shows? 
SELECT TOP 5 genres, COUNT(*) AS title_count
FROM titles 
WHERE type = 'Show'
GROUP BY genres
ORDER BY title_count DESC

-- Which genres had the most movies? 
SELECT TOP 5 genres,COUNT(*) AS title_count
FROM titles 
WHERE type = 'Movie'
GROUP BY genres
ORDER BY title_count DESC

-- Which shows on Netflix have the most seasons?
ALTER TABLE TITLES 
ALTER COLUMN TITLE NVARCHAR(300)

SELECT TOP 5 title,SUM(seasons) AS total_seasons
FROM titles 
WHERE type = 'Show'
GROUP BY title
ORDER BY total_seasons DESC

-- Count of movies and shows in each decade
select * from titles

SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,COUNT(*) AS movies_shows_count
FROM titles
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year / 10) * 10, 's')
ORDER BY decade;


-- What were the 5 most common age certifications for movies?

select top 5 age_certification , count(*) as counts from titles 
where type = 'Movie'
 and age_certification != 'NULL'
group by age_certification
order by counts desc


-- Who were the top 20 actors that appeared the most in movies/shows? 

select * from titles
select * from credits
alter table credits 
alter column name nvarchar(100)

select distinct top 20 c.name as actors,  count(*) as counts from titles as t 
inner join credits as c
on t.id = c.id
WHERE role = 'actor'
group by c.name
order by counts desc
 
 --or

SELECT DISTINCT top 20  name as actor, 
COUNT(*) AS number_of_appearences 
FROM credits
WHERE role = 'actor'
GROUP BY name
ORDER BY number_of_appearences DESC


-- Who were the top 20 directors that directed the most movies/shows? 

select distinct top 20 c.name as actors,  count(*) as counts from titles as t 
inner join credits as c
on t.id = c.id
WHERE role = 'director'
group by c.name
order by counts desc

  --or

SELECT DISTINCT top 20  name as actor, 
COUNT(*) AS number_of_appearences 
FROM credits
WHERE role = 'director'
GROUP BY name
ORDER BY number_of_appearences DESC



-- Calculating the average runtime of movies and TV shows separately

select  'MOVIE' as content_type,round(avg(runtime),2) as avg_run_time from titles where type = 'Movie' group by type
union all
select  'Show' as content_type,round(avg(runtime),2) as avg_run_time from titles where type = 'Show' group by type

-- Finding the titles and  directors of movies released on or after 2010

select distinct t.title ,c.name as directors,release_year  from titles as t
inner join credits as c
on
t.id = c.id
WHERE t.type = 'Movie' 
AND t.release_year >= 2010 
AND c.role = 'director'
ORDER BY release_year DESC


-- Titles and Directors of movies with high IMDB scores (>7.5) and high TMDB popularity scores (>80) 

SELECT t.title, c.name AS director FROM titles AS t
JOIN credits AS c 
ON t.id = c.id
WHERE t.type = 'Movie' 
AND t.imdb_score > 7.5 
AND t.tmdb_popularity > 80 
AND c.role = 'director';

-- What were the total number of titles for each year? 

SELECT release_year, COUNT(*) AS title_count
FROM titles GROUP BY release_year ORDER BY release_year DESC; 

-- Actors who have starred in the most highly rated movies or shows

SELECT c.name AS actor, 
COUNT(*) AS counts_of_highly_rated_titles
FROM credits AS c
JOIN titles AS t 
ON c.id = t.id
WHERE c.role = 'actor'
AND t.imdb_score > 8.0
AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY counts_of_highly_rated_titles DESC;

-- Average IMDB score for leading actors/actresses in movies or shows 

alter table credits
alter column character varchar(500)

SELECT c.name AS actor_actress, 
ROUND(AVG(t.imdb_score),2) AS average_imdb_score
FROM credits AS c
JOIN titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress' AND c.character = 'leading role'
group by c.name
ORDER BY average_imdb_score DESC;


-- Which actors/actresses played the same character in multiple movies or TV shows? 
SELECT c.name AS actor_actress,  COUNT(DISTINCT t.title) AS counts
FROM credits AS c
JOIN titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
GROUP BY c.name
HAVING COUNT(DISTINCT t.title) > 1;

--delete those name where name and character is ???
delete from credits where name ='???' and character ='???'