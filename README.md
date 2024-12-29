# Netflix Movies and TV Shows Data Analysis Using SQL

![Netflix_logo](https://github.com/Leanavgnr/netflix_sql_project/blob/main/Netflix-Logo.jpg)

## Project Overview

This project focuses on conducting an in-depth analysis of Netflix's movies and TV shows dataset using SQL. The objective is to derive meaningful insights and address key business questions from the data. This README outlines the project's goals, the business challenges tackled, the solutions implemented, and the key findings and conclusions.

## Objectives

- Analyze the distribution of content types (Movies vs TV Shows).
- Identify the most prevalent ratings for both movies and TV shows.
- Examine and categorize content by release year, country, and duration.
- Explore and classify content based on specific themes and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

Dataset Link: [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
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
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT
	type,
	count (type)

FROM netflix;
```

Objective: Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

Objective: Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
-- 3. List every movies released in a 2020

SELECT * FROM netflix

WHERE 
	release_year = 2020 
	AND 
	type = 'Movie';
```
Objective: Retrieve all movies released in a specific year.


### 4. Find the top 5 countries with the most content on netflix

```sql
SELECT
	UNNEST (STRING_TO_ARRAY (country, ', ')) as new_country,
	count (show_id) as count_content

FROM netflix

WHERE 
	country is NOT NULL

group by new_country
ORDER BY count_content DESC
LIMIT (5);
```
Objective: Identify the top 5 countries with the highest number of content items.


### 5. identify the longuest movie

```sql
SELECT 
	title,
	MAX (SPLIT_PART (duration, ' ', 1)::numeric) as max_lenght
FROM netflix
WHERE 
	type = 'Movie' and duration is not null
GROUP BY 1
ORDER BY 2 desc
LIMIT 1;
```
Objective: Find the movie with the longest duration.


### 6. Find content added in the last 5 years

```sql
SELECT *
FROM netflix 
WHERE
	TO_DATE (date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5years' ;
```

Objective: Retrieve content added to Netflix in the last 5 years.


### 7.Find all the movies/TV shows by director 'Rajiv Chilaka'

```sql
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```
Objective: List all content directed by 'Rajiv Chilaka'.


### 8. List TV shows with more than 5 seasons

```sql
SELECT * FROM netflix
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART (duration, ' ', 1)::numeric > 5;
```
Objective: Identify TV shows with more than 5 seasons.

	
### 9. count the number of content items in each genre

```sql
SELECT
	UNNEST (STRING_TO_ARRAY (listed_in, ', ')) as new_listedin,
	count (show_id) as count_content
FROM netflix 
GROUP BY 1
ORDER BY count_content DESC;
```

Objective: Count the number of content items in each genre.


### 10. Find the count and pourcentage of total content released per year in France on netflix.

```sql
SELECT 
	EXTRACT (YEAR from TO_date (date_added,'Month DD, YYYY')) as year_added,
	count (show_id ) as count_shows,
	ROUND (
	count(*)::numeric /(SELECT  count(*) from netflix where country ILIKE '%france%')::numeric* 100
	, 2) as average_content
FROM netflix
WHERE 
	country ILIKE '%france%'
GROUP BY year_added
ORDER BY average_content DESC;
```
Objective: Calculate and rank years by the average number of content releases by India.


### 11. List all movies that are documentaries 

```sql
SELECT *
FROM netflix
WHERE 
	listed_in ILIKE '%Documentaries%'
	AND type = 'Movie';
```
Objective: Retrieve all movies classified as documentaries.


### 12. Find all content without a director.

```sql
SELECT * FROM netflix
WHERE 
	director IS NULL;
```
Objective: List content that does not have a director.


### 13. Find how many movie actor 'Salman Khan' appeared in the last 10 years.

```sql
SELECT 
	Count (show_id)
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.


### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in France

```sql
SELECT
	UNNEST (STRING_TO_ARRAY (casts, ', ')) as actors,
	COUNT (show_id) as count_content
FROM netflix
WHERE 
	country ILIKE '%France%'
GROUP BY actors
ORDER BY count_content DESC
LIMIT 10;
```
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.


### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.

```sql
SELECT 
sensitive_category,
count (show_id)
FROM
	(SELECT
		*,
		CASE 
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' then 'Violent content'
		ELSE 'Non violent content ' 
		END as sensitive_category
	FROM netflix)

GROUP BY sensitive_category;
```

Objective: Categorize content as 'Violent content' if it contains 'kill' or 'violence' and 'Non violent' otherwise. Count the number of items in each category.

## Findings and Conclusion

### Content Distribution Strategy:
Netflix offers a diverse catalog with a greater focus on movies (6,131) over TV shows (2,676). This trend highlights Netflix’s strength in movie content, but the growing number of TV shows indicates a shift towards series to enhance user retention. Geographically, the United States leads in content production (3,689), with India (1,046) and United Kingdom (804) following, showing Netflix’s strategy to target international markets, especially in Asia and Europe.

### Target Audience:
The most common rating is "TV-MA," indicating Netflix’s focus on adult audiences. However, Netflix also offers substantial family-friendly content, such as Children & Family Movies and Kids' TV, showcasing a balanced approach to cater to diverse age groups.

### Content Categorization:
Netflix offers content across various genres like International Movies (2,752) and International TV Shows (1,351), emphasizing its global reach. Dramas and Comedies remain dominant, but genres like Romantic Movies and Documentaries allow Netflix to cater to specific viewer preferences. This broad categorization enhances Netflix’s ability to offer something for everyone. Netflix offers both violent (342) and non-violent content (8,465), indicating a balanced approach to appeal to different audience preferences, including both crime thrillers and family-friendly content.

### Recent Content Trends:
The years 2020 (97 new titles), 2019 (79), and 2018 (64) show Netflix's accelerated content production, especially with the pandemic driving increased demand for entertainment. In contrast, content additions slowed in 2015 and 2011, reflecting the earlier phases of Netflix’s global expansion.

