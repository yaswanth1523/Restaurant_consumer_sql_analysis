# Restaurant & Consumer Data Analysis using SQL & MySQL

## 📌 Project Overview

This project focuses on analyzing interconnected restaurant and consumer datasets using a relational MySQL database and SQL.

The project transforms raw CSV datasets into structured relational tables and applies SQL techniques such as filtering, joins, subqueries, aggregation, Common Table Expressions (CTEs), derived tables, window functions, views, and stored procedures.

The analysis explores consumer demographics, cuisine preferences, restaurant characteristics, locations, and rating patterns.

---

## 🎯 Project Objective

To organize and analyze interconnected restaurant and consumer datasets using a relational MySQL database and SQL in order to extract meaningful, data-supported insights about consumer behavior, preferences, restaurants, cuisines, locations, and ratings.

---

## 🗂️ Datasets

The project uses five related datasets:

- `consumers` — Consumer demographic and lifestyle information
- `consumer_preferences` — Preferred cuisines of consumers
- `restaurants` — Restaurant details and characteristics
- `restaurant_cuisines` — Cuisines offered by restaurants
- `ratings` — Consumer ratings for restaurants

---

## 🛠️ Technologies & Skills

- MySQL
- SQL
- Relational Database Design
- Data Cleaning
- Data Validation
- Filtering & Conditional Queries
- JOINs
- Subqueries
- Aggregation & GROUP BY
- HAVING
- Common Table Expressions (CTEs)
- Derived Tables
- Window Functions
- Views
- Stored Procedures

---

## 🗄️ Database Structure

The datasets are connected through primary and foreign key relationships.

The main relationships include:

- `consumers` → `consumer_preferences`
- `restaurants` → `restaurant_cuisines`
- `consumers` → `ratings`
- `restaurants` → `ratings`

The `ratings` table connects consumers with restaurants and supports analysis of consumer-rating behavior.

---

## 🔍 Analysis Performed

The project contains SQL analysis covering:

### Part 1 — Filtering

- Consumers by city
- Students who smoke
- Restaurants based on alcohol service and price
- Franchise restaurants
- Ratings based on overall rating

### Part 2 — JOINs & Subqueries

- Restaurants receiving high ratings
- Consumers rating restaurants in specific cities
- Cuisine-specific restaurant analysis
- Consumer cuisine preferences and budgets
- Ratings compared with overall averages
- Consumer and restaurant relationship analysis

### Part 3 — Aggregation

- Number of restaurants rated by consumers
- Consumer engagement scoring
- Average restaurant ratings
- Rating comparisons
- Consumer and restaurant performance analysis

### Part 4 — Advanced SQL

- Common Table Expressions (CTEs)
- Derived tables
- Window functions
- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LEAD()`
- Views
- Stored Procedures
- Multi-level analytical queries

---

## 🧹 Data Quality & Validation

During data preparation, duplicate records were identified in the `consumer_preferences` dataset.

Duplicate `(Consumer_ID, Preferred_Cuisine)` records were removed before loading the cleaned dataset.

The final datasets were also checked for:

- Primary key consistency
- Foreign key relationships
- Duplicate rating pairs
- Referential integrity between related tables

---

## 📊 Key Project Results

Some of the analysis results include:

- 22 consumers are located in Cuernavaca.
- 23 consumers are students and smokers.
- 15 restaurants provide Wine & Beer service and have a Medium price level.
- 22 restaurants are franchises.
- 486 ratings have an Overall Rating of 2.
- 117 restaurants received at least one Overall Rating of 2.
- 92 consumers rated restaurants in San Luis Potosi.
- 125 restaurants had at least one Food Rating below the global average.
- 42 top-ranked restaurant/cuisine results were identified using `DENSE_RANK()` with ties.

---

## 📁 Repository Structure

```text
Restaurant_consumer_sql_analysis/
│
├── README.md
│
├── SQL/
│   └── restaurant_consumer_analysis.sql
│
├── Data/
│   ├── consumers.csv
│   ├── consumer_preferences_cleaned.csv
│   ├── restaurants.csv
│   ├── restaurant_cuisines.csv
│   └── ratings.csv
│
├── ER_Diagram/
│   └── restaurant_consumer_er_diagram.png
│
├── Presentation/
│   └── Yaswanth_Restaurant_Consumer_SQL_Project_Presentation.pptx
