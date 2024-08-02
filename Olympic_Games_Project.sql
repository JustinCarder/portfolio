-- How does the average weight, height, and age of medalists change over time for each sport for each sex

-- How many sports are there across both Summer and Winter Games
SELECT
DISTINCT(Sport)
FROM `olympic-games-project.olympic_games_dataset.olympics_data`
-- 50 Sports

-- Cleaning the data by changing formats and eliminating multiple of the same person for a given year
WITH ranked_medalists AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ID, Year ORDER BY ID) AS rn
    FROM `olympic-games-project.olympic_games_dataset.olympics_data`
    WHERE Medal != "NA" -- Eliminate those who did not get a medal that year
),
ranked_medalist_updated AS (
  SELECT
    ID,
    Name,
    Sex,
    Sport,
    Year,
    IF(Weight = "NA", NULL, CAST(Weight AS float64)) AS Weight_Num, -- Convert all "NA" to nulls and the rest from strings to floats 
    IF(Height = "NA", NULL, CAST(Height AS float64)) AS Height_Num, -- Convert all "NA" to nulls and the rest from strings to floats
    IF(Age = "NA", NULL, CAST(Age AS float64)) AS Age_Num -- Convert all "NA" to nulls and the rest from strings to floats
  FROM ranked_medalists
  WHERE rn = 1
)
-- Calculating the average weight, height, age for each sport every year
SELECT
  Sport,
  Year,
  Sex,
  AVG(Weight_Num) AS Average_Weight, -- Average function
  AVG(Height_Num) AS Average_Height, -- Average function
  AVG(Age_Num) AS Average_Age, -- Average function
FROM ranked_medalist_updated
GROUP BY Sport,Year,Sex -- Make sure it takes the average for each sport of everyone of the same sex who recieved a medal that year
ORDER BY Sport,Year,Sex

-- Creating View to store data for later visualizations in Tableau
CREATE VIEW olympic-games-project.olympic_games_dataset.medalist_measurements AS
WITH ranked_medalists AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ID, Year ORDER BY ID) AS rn
    FROM `olympic-games-project.olympic_games_dataset.olympics_data`
    WHERE Medal != "NA" -- Eliminate those who did not get a medal that year
),
ranked_medalist_updated AS (
  SELECT
    ID,
    Name,
    Sex,
    Sport,
    Year,
    IF(Weight = "NA", NULL, CAST(Weight AS float64)) AS Weight_Num, -- Convert all "NA" to nulls and the rest from strings to floats 
    IF(Height = "NA", NULL, CAST(Height AS float64)) AS Height_Num, -- Convert all "NA" to nulls and the rest from strings to floats
    IF(Age = "NA", NULL, CAST(Age AS float64)) AS Age_Num -- Convert all "NA" to nulls and the rest from strings to floats
  FROM ranked_medalists
  WHERE rn = 1
)
SELECT
  Sport,
  Year,
  Sex,
  AVG(Weight_Num) AS Average_Weight, -- Average function
  AVG(Height_Num) AS Average_Height, -- Average function
  AVG(Age_Num) AS Average_Age, -- Average function
FROM ranked_medalist_updated
WHERE Sport = "Golf"
GROUP BY Sport,Year,Sex -- Make sure it takes the average for each sport of everyone of the same sex who recieved a medal that year
ORDER BY Sport,Year,Sex

