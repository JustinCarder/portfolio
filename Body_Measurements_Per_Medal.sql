-- Clean the data by replacing the string "NA" to null and coverting the strings for weight, height, and age to float
-- Create a view of this table to be used later
CREATE VIEW olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal AS
WITH Measurements_Cleaned AS (
SELECT
  Medal,
  Name,
  Sport,
  Year,
  Sex,
    IF(Weight = "NA", NULL, CAST(Weight AS float64)) AS Weight_Num, -- Convert all "NA" to nulls and the rest from strings to floats 
    IF(Height = "NA", NULL, CAST(Height AS float64)) AS Height_Num, -- Convert all "NA" to nulls and the rest from strings to floats
    IF(Age = "NA", NULL, CAST(Age AS float64)) AS Age_Num -- Convert all "NA" to nulls and the rest from strings to floats
FROM `olympic-games-project.olympic_games_dataset.olympics_data`
ORDER BY Sport,Medal,Sex
)
-- Calculate the average body measurements of each medal's owner and non medalists
SELECT
  Medal,
  Sport,
  Sex,
  AVG(Weight_Num) AS Average_Weight, -- Average function
  AVG(Height_Num) AS Average_Height, -- Average function
  AVG(Age_Num) AS Average_Age, -- Average function
FROM Measurements_Cleaned
GROUP BY Sport,Medal,Sex
ORDER BY Sport,Sex,Medal

-- Determine the numeric and percentage increase from no medal to bronze, silver, and then gold for each sport
SELECT *
FROM `olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal`

WITH Bronze_Medals AS (
  SELECT
    Medal,
    Sport,
    Sex,
    Average_Weight AS Bronze_Weight,
    Average_Height AS Bronze_Height,
    Average_Age AS Bronze_Age
  FROM `olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal`
  WHERE Medal = "Bronze"
),
Silver_Medals AS (
  SELECT
    Medal,
    Sport,
    Sex,
    Average_Weight AS Silver_Weight,
    Average_Height AS Silver_Height,
    Average_Age AS Silver_Age
  FROM `olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal`
  WHERE Medal = "Silver"
),
Gold_Medals AS (
  SELECT
    Medal,
    Sport,
    Sex,
    Average_Weight AS Gold_Weight,
    Average_Height AS Gold_Height,
    Average_Age AS Gold_Age
  FROM `olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal`
  WHERE Medal = "Gold"
),
NA_Medals AS (
  SELECT
    Medal,
    Sport,
    Sex,
    Average_Weight AS NA_Weight,
    Average_Height AS NA_Height,
    Average_Age AS NA_Age
  FROM `olympic-games-project.olympic_games_dataset.Body_Measurements_Per_Medal`
  WHERE Medal = "NA"
),
-- Grouping all of the medals into one table so each sport has only two rows 1 for male and 1 for female
Combined_Information AS (
  SELECT
    Bronze_Medals.Sport,
    Bronze_Medals.Sex,
    Bronze_Medals.Bronze_Weight,
    Bronze_Medals.Bronze_Height,
    Bronze_Medals.Bronze_Age,
    Silver_Medals.Silver_Weight,
    Silver_Medals.Silver_Height,
    Silver_Medals.Silver_Age,
    Gold_Medals.Gold_Weight,
    Gold_Medals.Gold_Height,
    Gold_Medals.Gold_Age,
    NA_Medals.NA_Weight,
    NA_Medals.NA_Height,
    NA_Medals.NA_Age
  FROM Bronze_Medals
  LEFT JOIN Silver_Medals
  ON Bronze_Medals.Sport = Silver_Medals.Sport
  AND Bronze_Medals.Sex = Silver_Medals.Sex
  LEFT JOIN Gold_Medals
  ON Bronze_Medals.Sport = Gold_Medals.Sport
  AND Bronze_Medals.Sex = Gold_Medals.Sex
  LEFT JOIN NA_Medals
  ON Bronze_Medals.Sport = NA_Medals.Sport
  AND Bronze_Medals.Sex = NA_Medals.Sex
)
SELECT
  Sport,
  Sex,
  -- Weight Calculations
  (Bronze_Weight - NA_Weight) AS Bronze_Weight_Numeric_Change,
  (100*(Bronze_Weight - NA_Weight)/NA_Weight) AS Bronze_Weight_Percent_Change,
  (Silver_Weight - NA_Weight) AS Silver_Weight_Numeric_Change,
  (100*(Silver_Weight - NA_Weight)/NA_Weight) AS Silver_Weight_Percent_Change,
  (Gold_Weight - NA_Weight) AS Gold_Weight_Numeric_Change,
  (100*(Gold_Weight - NA_Weight)/NA_Weight) AS Gold_Weight_Percent_Change, 
  -- Height Calculations
  (Bronze_Height - NA_Height) AS Bronze_Height_Numeric_Change,
  (100*(Bronze_Height - NA_Height)/NA_Height) AS Bronze_Height_Percent_Change,
  (Silver_Height - NA_Height) AS Silver_Height_Numeric_Change,
  (100*(Silver_Height - NA_Height)/NA_Height) AS Silver_Height_Percent_Change,
  (Gold_Height - NA_Height) AS Gold_Height_Numeric_Change,
  (100*(Gold_Height - NA_Height)/NA_Height) AS Gold_Height_Percent_Change,
  -- Age Calculations
  (Bronze_Age - NA_Age) AS Bronze_Age_Numeric_Change,
  (100*(Bronze_Age - NA_Age)/NA_Age) AS Bronze_Age_Percent_Change,
  (Silver_Age - NA_Age) AS Silver_Age_Numeric_Change,
  (100*(Silver_Age - NA_Age)/NA_Age) AS Silver_Age_Percent_Change,
  (Gold_Age - NA_Age) AS Gold_Age_Numeric_Change,
  (100*(Gold_Age - NA_Age)/NA_Age) AS Gold_Age_Percent_Change        
FROM Combined_Information
ORDER BY Sport
