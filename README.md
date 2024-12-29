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
)```
