-- Netflix Project 

-- Create table

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (

	show_id VARCHAR (6),
	type VARCHAR (10),
	title VARCHAR (150),
	director VARCHAR (210),
	casts VARCHAR (1000),
	country VARCHAR (150),
	date_added VARCHAR (50),
	release_year INT,
	rating VARCHAR (10),
	duration VARCHAR (15),
	listed_in VARCHAR (100),
	description VARCHAR (250)
)


-- 15 business problems

-- 1. Count the number of movies VS TV shows 

SELECT
	type,
	count (type)

FROM netflix 

GROUP BY type;


-- 2. Find the most common rating for movies and TV shows

SELECT 
	type,
	rating

FROM (
	SELECT
	type,
	rating,
	count (*),
	RANK () OVER (PARTITION BY type ORDER BY count (*) DESC) as ranking
	FROM netflix 
	GROUP BY type, rating 
	) as t1

WHERE 
	ranking = 1;


-- 3. List every movies released in a 2020

SELECT * FROM netflix

WHERE 
	release_year = 2020 
	AND 
	type = 'Movie';


-- 4. Find the top 5 countries with the most content on netflix

SELECT
	UNNEST (STRING_TO_ARRAY (country, ', ')) as new_country,
	count (show_id) as count_content

FROM netflix

WHERE 
	country is NOT NULL

group by new_country
ORDER BY count_content DESC
LIMIT (5);


-- 5. identify the longuest movie

SELECT 
	title,
	MAX (SPLIT_PART (duration, ' ', 1)::numeric) as max_lenght
FROM netflix
WHERE 
	type = 'Movie' and duration is not null
GROUP BY 1
ORDER BY 2 desc
LIMIT 1;


-- 6. Find content added in the last 5 years

SELECT *
FROM netflix 
WHERE
	TO_DATE (date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5years' ;


-- 7.Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List TV shows with more than 5 seasons
 
SELECT * FROM netflix
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART (duration, ' ', 1)::numeric > 5;

	
-- 9. count the number of content items to each genre

SELECT
	UNNEST (STRING_TO_ARRAY (listed_in, ', ')) as new_listedin,
	count (show_id) as count_content
FROM netflix 
GROUP BY 1
ORDER BY count_content DESC;


/* 10.find each year and the average numbers of content release by india on netflix. 
Return the top 5 years with highest avg content release */

SELECT 
	EXTRACT (YEAR from TO_date (date_added,'Month DD, YYYY')) as year_added,
	count (show_id ) as count_shows,
	ROUND (
	(count(*)::numeric /(SELECT  count(*) from netflix where country = 'India')::numeric)* 100
	,2) as average_content
FROM netflix
WHERE 
	country ILIKE '%India%'
GROUP BY year_added
ORDER BY average_content DESC;


-- 11. List all movies that are documentaries 

SELECT *
FROM netflix
WHERE 
	listed_in ILIKE '%Documentaries%'
	AND type = 'Movie';


-- 12. Find all content without a director.

SELECT * FROM netflix
WHERE 
	director IS NULL;


-- 13. Find how many movie actor 'Salman Khan' appeared in the last 10 years.

SELECT 
	Count (show_id)
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT
	UNNEST (STRING_TO_ARRAY (casts, ', ')) as actors,
	COUNT (show_id) as count_content
FROM netflix
WHERE 
	country ILIKE '%India%'
GROUP BY actors
ORDER BY count_content DESC
LIMIT 10;


/* 15. categorize the content based on presence of the key word 'kill and 'violence' in the description field.
Label content containing these key words as 'violent content' and all other contente as 'non violent content'.
Count how many items fall into each category. */

SELECT 
sensitive_category,
count (show_id)
FROM
	(SELECT
		*,
		CASE 
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' then 'Violent content'
		ELSE 'Non violent content' 
		END as sensitive_category
	FROM netflix)

GROUP BY sensitive_category;
