CREATE DATABASE RESTAURANT_CONSUMER_DB;
USE RESTAURANT_CONSUMER_DB;

-- =================================================
-- 1. CONSUMERS
-- =================================================

CREATE TABLE consumers (
    Consumer_ID VARCHAR(10) PRIMARY KEY,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Latitude DECIMAL(10,7) NOT NULL,
    Longitude DECIMAL(10,7) NOT NULL,
    Smoker VARCHAR(10),
    Drink_Level VARCHAR(50) NOT NULL,
    Transportation_Method VARCHAR(50),
    Marital_Status VARCHAR(20),
    Children VARCHAR(20),
    Age INT NOT NULL,
    Occupation VARCHAR(50),
    Budget VARCHAR(10)
);

DESCRIBE CONSUMERS;

SELECT * FROM CONSUMERS;

-- =================================================
-- 2. REATAURANTS
-- =================================================

CREATE TABLE restaurants (
    Restaurant_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Country VARCHAR(255) NOT NULL,
    Zip_Code VARCHAR(10),
    Latitude DECIMAL(10,7) NOT NULL,
    Longitude DECIMAL(11,7) NOT NULL,
    Alcohol_Service VARCHAR(50),
    Smoking_Allowed VARCHAR(50) NOT NULL,
    Price VARCHAR(10) NOT NULL,
    Franchise VARCHAR(5) NOT NULL,
    Area VARCHAR(10) NOT NULL,
    Parking VARCHAR(50)
);

DESCRIBE RESTAURANTS;
SELECT * FROM RESTAURANTS;

-- =================================================
-- 3. CONSUMERS_PREFERENCES
-- =================================================
CREATE TABLE consumer_preferences (
    Consumer_ID VARCHAR(10) NOT NULL,
    Preferred_Cuisine VARCHAR(255) NOT NULL,

    PRIMARY KEY (Consumer_ID, Preferred_Cuisine),

    FOREIGN KEY (Consumer_ID)
        REFERENCES consumers(Consumer_ID)
);

DESCRIBE CONSUMER_PREFERENCES;
SELECT * FROM CONSUMER_PREFERENCES;

-- =================================================
-- 4. RESTAURANT CUISINES
-- =================================================

CREATE TABLE restaurant_cuisines (
    Restaurant_ID INT NOT NULL,
    Cuisine VARCHAR(255) NOT NULL,

    PRIMARY KEY (Restaurant_ID, Cuisine),

    FOREIGN KEY (Restaurant_ID)
        REFERENCES restaurants(Restaurant_ID)
);

DESCRIBE RESTAURANT_CUISINES;
SELECT * FROM RESTAURANT_CUISINES;

-- =================================================
-- 5. RATINGS
-- =================================================

CREATE TABLE ratings (
    Consumer_ID VARCHAR(10) NOT NULL,
    Restaurant_ID INT NOT NULL,
    Overall_Rating INT NOT NULL,
    Food_Rating INT NOT NULL,
    Service_Rating INT NOT NULL,

    PRIMARY KEY (Consumer_ID, Restaurant_ID),

    FOREIGN KEY (Consumer_ID)
        REFERENCES consumers(Consumer_ID),

    FOREIGN KEY (Restaurant_ID)
        REFERENCES restaurants(Restaurant_ID),

    CHECK (Overall_Rating IN (0, 1, 2)),
    CHECK (Food_Rating IN (0, 1, 2)),
    CHECK (Service_Rating IN (0, 1, 2))
);

DESCRIBE RATINGS;
SELECT * FROM RATINGS;

SELECT COUNT(*)
FROM ratings r
JOIN consumers c
ON r.Consumer_ID = c.Consumer_ID;

SELECT COUNT(*)
FROM ratings r
JOIN restaurants res
ON r.Restaurant_ID = res.Restaurant_ID;

-- ======================================================================================
-- Using the WHERE clause to filter data based on specific criteria.
-- ======================================================================================

-- 1. List all details of consumers who live in the city of 'Cuernavaca'.
SELECT * FROM CONSUMERS
WHERE CITY = 'Cuernavaca';

-- 2. Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
SELECT CONSUMER_ID, AGE, OCCUPATION FROM CONSUMERS
WHERE OCCUPATION = 'STUDENT' AND SMOKER = 'YES';

-- 3. List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
SELECT NAME, CITY, ALCOHOL_SERVICE, PRICE 
FROM RESTAURANTS
WHERE ALCOHOL_SERVICE = 'WINE & BEER' 
AND PRICE = 'MEDIUM';

-- 4. Find the names and cities of all restaurants that are part of a 'Franchise'.
SELECT NAME, CITY
FROM RESTAURANTS
WHERE FRANCHISE = 'YES';

-- 5. Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according to the data dictionary).
SELECT CONSUMER_ID, RESTAURANT_ID, OVERALL_RATING
FROM RATINGS 
WHERE OVERALL_RATING = 2;


-- ======================================================================================
-- Questions JOINs with Subqueries
-- ======================================================================================

-- 1. List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT DISTINCT r.Name, r.City
FROM restaurants AS r
JOIN ratings AS rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Overall_Rating = 2;

-- 2. Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings rt
ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r
ON rt.Restaurant_ID = r.Restaurant_ID
WHERE r.City = 'San Luis Potosi';

-- 3. List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT DISTINCT r.Name
FROM restaurants r
JOIN restaurant_cuisines rc
ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
AND rt.Consumer_ID = 'U1001';

-- 4. Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
SELECT DISTINCT c.*
FROM consumers c
JOIN consumer_preferences cp
ON c.Consumer_ID = cp.Consumer_ID
WHERE cp.Preferred_Cuisine = 'American'
AND c.Budget = 'Medium';

-- 5. List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rt.Food_Rating < (
    SELECT AVG(Food_Rating)
    FROM ratings
);

-- 6. Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT c.Consumer_ID, c.Age, c.Occupation
FROM consumers c
WHERE EXISTS (
    SELECT 1
    FROM ratings rt
    WHERE rt.Consumer_ID = c.Consumer_ID
)
AND NOT EXISTS (
    SELECT 1
    FROM ratings rt
    JOIN restaurant_cuisines rc
        ON rt.Restaurant_ID = rc.Restaurant_ID
    WHERE rt.Consumer_ID = c.Consumer_ID
      AND rc.Cuisine = 'Italian'
);

-- 7. List restaurants (Name) that have received ratings from consumers older than 30.
SELECT DISTINCT r.Name
FROM restaurants r
JOIN ratings rt
    ON r.Restaurant_ID = rt.Restaurant_ID
JOIN consumers c
    ON rt.Consumer_ID = c.Consumer_ID
WHERE c.Age > 30;

-- 8. Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
SELECT DISTINCT c.Consumer_ID, c.Occupation
FROM consumers c
JOIN consumer_preferences cp
    ON c.Consumer_ID = cp.Consumer_ID
JOIN ratings rt
    ON c.Consumer_ID = rt.Consumer_ID
WHERE cp.Preferred_Cuisine = 'Mexican'
AND rt.Overall_Rating = 0;

-- 9. List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives.
SELECT DISTINCT r.Name, r.City
FROM restaurants r
JOIN restaurant_cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Pizzeria'
AND EXISTS (
    SELECT 1
    FROM consumers c
    WHERE c.City = r.City
      AND c.Occupation = 'Student'
);

-- 10. Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
SELECT DISTINCT C.CONSUMER_ID, C.AGE
FROM CONSUMERS C
JOIN RATINGS RT
ON C.CONSUMER_ID = RT.CONSUMER_ID
JOIN RESTAURANTS R
ON R.RESTAURANT_ID = RT. RESTAURANT_ID 
WHERE C.DRINK_LEVEL = 'SOCIAL DRINKER'
AND R.PARKING = 'NONE';


-- ==========================================================================================
-- Questions Emphasizing WHERE Clause and Order of Execution
-- ==========================================================================================

-- 1. List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'. Show only students who have rated more than 2 restaurants.
SELECT c.Consumer_ID,
    COUNT(DISTINCT rt.Restaurant_ID) AS Restaurant_Count
FROM consumers c
JOIN ratings rt
    ON c.Consumer_ID = rt.Consumer_ID
WHERE c.Occupation = 'Student'
GROUP BY c.Consumer_ID
HAVING COUNT(DISTINCT rt.Restaurant_ID) > 2;

-- 2. We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.
SELECT Consumer_ID, Age,
FLOOR(Age / 10) AS Engagement_Score
FROM consumers
WHERE FLOOR(Age / 10) = 2
AND Transportation_Method = 'Public';

-- 3. For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its calculated average Overall_Rating, but only for restaurants located in 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.
SELECT r.Name, r.City, AVG(rt.Overall_Rating) AS Average_Overall_Rating
FROM restaurants r
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE r.City = 'Cuernavaca'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.0;

-- 4. Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant is equal to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.
SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings rt
ON c.Consumer_ID = rt.Consumer_ID
WHERE c.Marital_Status = 'Married'
AND rt.Overall_Rating = 2
AND rt.Food_Rating = rt.Service_Rating;

-- 5. List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
SELECT DISTINCT c.Consumer_ID, c.Age, r.Name
FROM consumers c
JOIN ratings rt
ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r
ON rt.Restaurant_ID = r.Restaurant_ID
WHERE c.Occupation = 'Employed'
  AND EXISTS (
      SELECT 1
      FROM ratings rt2
      JOIN restaurants r2
          ON rt2.Restaurant_ID = r2.Restaurant_ID
      WHERE rt2.Consumer_ID = c.Consumer_ID
        AND rt2.Food_Rating = 0
        AND r2.City = 'Ciudad Victoria'
  );
  
  
-- ==============================================================================================
-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures
-- ==============================================================================================

-- 1. Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.
WITH SanLuisConsumers AS (
    SELECT
        Consumer_ID,
        Age
    FROM consumers
    WHERE City = 'San Luis Potosi'
)
SELECT DISTINCT
    slc.Consumer_ID,
    slc.Age,
    r.Name
FROM SanLuisConsumers slc
JOIN ratings rt
    ON slc.Consumer_ID = rt.Consumer_ID
JOIN restaurants r
    ON rt.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
  AND rt.Overall_Rating = 2;
  
-- 2. For each Occupation, find the average age of consumers. Only consider consumers who have made at least one rating. (Use a derived table to get consumers who have rated).
SELECT
    c.Occupation,
    AVG(c.Age) AS Average_Age
FROM consumers c
JOIN (
    SELECT DISTINCT Consumer_ID
    FROM ratings
) AS rated_consumers
    ON c.Consumer_ID = rated_consumers.Consumer_ID
GROUP BY c.Occupation;

-- 3. Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within each restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.
WITH CuernavacaRatings AS (
    SELECT
        rt.Restaurant_ID,
        rt.Consumer_ID,
        rt.Overall_Rating
    FROM ratings rt
    JOIN restaurants r
        ON rt.Restaurant_ID = r.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT
    Restaurant_ID,
    Consumer_ID,
    Overall_Rating,
    RANK() OVER (
        PARTITION BY Restaurant_ID
        ORDER BY Overall_Rating DESC
    ) AS RatingRank
FROM CuernavacaRatings;

-- 4. For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average Overall_Rating given by that specific consumer across all their ratings.
SELECT Consumer_ID, Restaurant_ID, Overall_Rating,
AVG(Overall_Rating) OVER (
PARTITION BY Consumer_ID
) AS Consumer_Average_Rating
FROM ratings;

-- 5. Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).
WITH LowBudgetStudents AS (
    SELECT
        Consumer_ID
    FROM consumers
    WHERE Occupation = 'Student'
      AND Budget = 'Low'
),
RankedPreferences AS (
    SELECT
        cp.Consumer_ID,
        cp.Preferred_Cuisine,
        ROW_NUMBER() OVER (
            PARTITION BY cp.Consumer_ID
            ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine
        ) AS PreferenceRank
    FROM consumer_preferences cp
    JOIN LowBudgetStudents lbs
        ON cp.Consumer_ID = lbs.Consumer_ID
)
SELECT
    Consumer_ID,
    Preferred_Cuisine,
    PreferenceRank
FROM RankedPreferences
WHERE PreferenceRank <= 3
ORDER BY Consumer_ID, PreferenceRank;

-- 6. Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if any), ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.
SELECT
    Restaurant_ID,
    Overall_Rating,
    LEAD(Overall_Rating) OVER (
        ORDER BY Restaurant_ID
    ) AS Next_Overall_Rating
FROM (
    SELECT
        Restaurant_ID,
        Overall_Rating
    FROM ratings
    WHERE Consumer_ID = 'U1008'
) AS ConsumerRatings
ORDER BY Restaurant_ID;

-- 7. Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.
CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT r.Restaurant_ID, r.Name, r.City
FROM restaurants r
JOIN restaurant_cuisines rc
ON r.Restaurant_ID = rc.Restaurant_ID
JOIN ratings rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(rt.Overall_Rating) > 1.5;

SELECT *
FROM HighlyRatedMexicanRestaurants;

-- 8. First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.
WITH MexicanConsumers AS (
    SELECT DISTINCT Consumer_ID
    FROM consumer_preferences
    WHERE Preferred_Cuisine = 'Mexican'
)
SELECT mc.Consumer_ID
FROM MexicanConsumers mc
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings rt
    JOIN HighlyRatedMexicanRestaurants hr
        ON rt.Restaurant_ID = hr.Restaurant_ID
    WHERE rt.Consumer_ID = mc.Consumer_ID
);

-- 9. Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input. It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or exceeds the threshold.

DELIMITER //
CREATE PROCEDURE GetRestaurantRatingsAboveThreshold(
    IN p_Restaurant_ID INT,
    IN p_Min_Overall_Rating INT
)
BEGIN
    SELECT
        Consumer_ID,
        Overall_Rating,
        Food_Rating,
        Service_Rating
    FROM ratings
    WHERE Restaurant_ID = p_Restaurant_ID
      AND Overall_Rating >= p_Min_Overall_Rating;
END //
DELIMITER ;

SELECT Restaurant_ID, Name
FROM restaurants
LIMIT 5;

CALL GetRestaurantRatingsAboveThreshold(132560, 2);
CALL GetRestaurantRatingsAboveThreshold(132561, 2);
CALL GetRestaurantRatingsAboveThreshold(132564, 2);

SELECT Consumer_ID, Overall_Rating, Food_Rating, Service_Rating
FROM ratings
WHERE Restaurant_ID = 132560;

SELECT Consumer_ID, Overall_Rating, Food_Rating, Service_Rating
FROM ratings
WHERE Restaurant_ID = 132564;

-- 10. Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.
WITH RestaurantCuisineRatings AS (
    SELECT
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name AS Restaurant_Name,
        r.City,
        AVG(rt.Overall_Rating) AS Overall_Rating
    FROM restaurant_cuisines rc
    JOIN restaurants r
        ON rc.Restaurant_ID = r.Restaurant_ID
    JOIN ratings rt
        ON r.Restaurant_ID = rt.Restaurant_ID
    GROUP BY
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name,
        r.City
),
RankedRestaurants AS (
    SELECT
        Cuisine,
        Restaurant_Name,
        City,
        Overall_Rating,
        DENSE_RANK() OVER (
            PARTITION BY Cuisine
            ORDER BY Overall_Rating DESC
        ) AS RatingRank
    FROM RestaurantCuisineRatings
)
SELECT
    Cuisine,
    Restaurant_Name,
    City,
    Overall_Rating
FROM RankedRestaurants
WHERE RatingRank <= 2
ORDER BY Cuisine, RatingRank, Restaurant_Name;

-- 11.First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by their average overall rating. For these top 5 consumers, list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.

-- CREATE A VIEW
CREATE VIEW ConsumerAverageRatings AS
SELECT
    Consumer_ID,
    AVG(Overall_Rating) AS Average_Overall_Rating
FROM ratings
GROUP BY Consumer_ID;

-- USE THE VIEW + CTE
WITH Top5Consumers AS (
    SELECT
        Consumer_ID,
        Average_Overall_Rating
    FROM ConsumerAverageRatings
    ORDER BY Average_Overall_Rating DESC
    LIMIT 5
)
SELECT
    t.Consumer_ID,
    t.Average_Overall_Rating,
    COUNT(DISTINCT CASE
        WHEN rc.Cuisine = 'Mexican'
        THEN rt.Restaurant_ID
    END) AS Mexican_Restaurants_Rated
FROM Top5Consumers t
LEFT JOIN ratings rt
    ON t.Consumer_ID = rt.Consumer_ID
LEFT JOIN restaurant_cuisines rc
    ON rt.Restaurant_ID = rc.Restaurant_ID
GROUP BY
    t.Consumer_ID,
    t.Average_Overall_Rating
ORDER BY t.Average_Overall_Rating DESC;

-- 12. Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.

SELECT Consumer_ID, Budget
FROM consumers
LIMIT 5;

DELIMITER //
CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(
    IN p_Consumer_ID VARCHAR(10)
)
BEGIN
    SELECT
        c.Consumer_ID,

        CASE
            WHEN c.Budget = 'Low' THEN 'Budget Conscious'
            WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
            WHEN c.Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment,

        r.Name AS Restaurant_Name,

        rt.Overall_Rating AS Consumer_Overall_Rating,

        restaurant_avg.Restaurant_Average_Rating,

        CASE
            WHEN rt.Overall_Rating > restaurant_avg.Restaurant_Average_Rating
                THEN 'Above Average'
            WHEN rt.Overall_Rating = restaurant_avg.Restaurant_Average_Rating
                THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,

        RANK() OVER (
            ORDER BY rt.Overall_Rating DESC
        ) AS Rating_Rank

    FROM consumers c

    JOIN ratings rt
        ON c.Consumer_ID = rt.Consumer_ID

    JOIN restaurants r
        ON rt.Restaurant_ID = r.Restaurant_ID

    JOIN (
        SELECT
            Restaurant_ID,
            AVG(Overall_Rating) AS Restaurant_Average_Rating
        FROM ratings
        GROUP BY Restaurant_ID
    ) AS restaurant_avg
        ON rt.Restaurant_ID = restaurant_avg.Restaurant_ID

    WHERE c.Consumer_ID = p_Consumer_ID

    ORDER BY Rating_Rank, Restaurant_Name;

END //
DELIMITER ;

CALL GetConsumerSegmentAndRestaurantPerformance('U1001');