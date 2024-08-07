SELECT
  DISTINCT(City)
FROM `olympic-games-project.olympic_games_dataset.olympics_data`

-- Saved Results as a CSV
-- Opened in Google Sheets
-- Added the NOC for the country of each host city
-- Saved new table as CSV
-- Created the table "city_to_country"

-- Join new table to the original table so the host NOC is listed by matching the city names
SELECT
  od.City,
  od.NOC,
  ctc.string_field_1 AS Host_NOC,
  od.Year,
  od.Season,
  od.Medal
FROM `olympic-games-project.olympic_games_dataset.olympics_data` AS od
JOIN `olympic-games-project.olympic_games_dataset.city_to_country` AS ctc
  ON od.City = ctc.string_field_0
WHERE NOT (Year = 1956 AND NOC = "SWE") -- Had to account for Equestrian taking place in Sweden this year so missleading info
AND Season = "Summer"
ORDER BY od.Year,od.NOC

-- Pull out the total gold,silver,bronze,and NA medals for each of the host for each of the summer games and put it all into one table with each year having all the information in 1 row
-- Create a temp table of this information to be used later when comparing before and after
CREATE VIEW olympic-games-project.olympic_games_dataset.Host_Medal_Count AS
WITH Part3_Table1 AS (
SELECT
  od.City,
  od.NOC,
  ctc.string_field_1 AS Host_NOC,
  od.Year,
  od.Season,
  od.Medal
FROM `olympic-games-project.olympic_games_dataset.olympics_data` AS od
JOIN `olympic-games-project.olympic_games_dataset.city_to_country` AS ctc
  ON od.City = ctc.string_field_0
WHERE NOT (Year = 1956 AND NOC = "SWE")
AND Season = "Summer"
ORDER BY od.Year,od.NOC
),
-- Adding the Gold medals to the table
Host_Gold AS (
SELECT
  NOC,
  Host_NOC,
  Year,
  Season,
  COUNT(Medal) AS Host_Gold_Count
FROM Part3_Table1
WHERE NOC = Host_NOC
AND Medal = "Gold"
GROUP BY Year,Season,Host_NOC,NOC
ORDER BY Year,Season
),
-- Adding the Silver medals to the table
Host_Silver AS (
SELECT
  NOC,
  Host_NOC,
  Year,
  Season,
  COUNT(Medal) AS Host_Silver_Count
FROM Part3_Table1
WHERE NOC = Host_NOC
AND Medal = "Silver"
GROUP BY Year,Season,Host_NOC,NOC
ORDER BY Year,Season
),
-- Adding the Bronze medals to the table
Host_Bronze AS (
SELECT
  NOC,
  Host_NOC,
  Year,
  Season,
  COUNT(Medal) AS Host_Bronze_Count
FROM Part3_Table1
WHERE NOC = Host_NOC
AND Medal = "Bronze"
GROUP BY Year,Season,Host_NOC,NOC
ORDER BY Year,Season
),
-- Adding the NA medals to the table
Host_NA AS (
SELECT
  NOC,
  Host_NOC,
  Year,
  Season,
  COUNT(Medal) AS Host_NA_Count
FROM Part3_Table1
WHERE NOC = Host_NOC
AND Medal = "NA"
GROUP BY Year,Season,Host_NOC,NOC
ORDER BY Year,Season
)
SELECT
  HG.NOC,
  HG.Host_NOC,
  HG.Year,
  HG.Host_Gold_Count,
  HS.Host_Silver_Count,
  HB.Host_Bronze_Count,
  HN.Host_NA_Count
FROM Host_Gold AS HG
LEFT JOIN Host_Silver AS HS
ON HG.NOC = HS.NOC
AND HG.Year = HS.Year
AND HG.Season = HS.Season
LEFT JOIN Host_Bronze AS HB
ON HG.NOC = HB.NOC
AND HG.Year = HB.Year
AND HG.Season = HB.Season
LEFT JOIN Host_NA AS HN
ON HG.NOC = HN.NOC
AND HG.Year = HN.Year
AND HG.Season = HN.Season
ORDER BY Year

-- Get a table that lists the previous year and next year the games where conducted in relation to when the host country hosted
-- Create the table for the previous medal counts
-- Create a view to combine later
CREATE VIEW olympic-games-project.olympic_games_dataset.Previous_Medal_Count AS
WITH Years_Table AS (
SELECT
  LAG(Year, 1) OVER (ORDER BY Year) AS Previous_Year,
  Year,
  LEAD(Year, 1) OVER (ORDER BY Year) AS Next_Year,
  NOC
FROM `olympic-games-project.olympic_games_dataset.Host_Medal_Count`
ORDER BY Year
),
Part3_Table2 AS (
SELECT
  yt.Previous_Year,
  yt.Year,
  od.Year,
  

  od.NOC,
  od.Season,
  od.Medal
FROM `olympic-games-project.olympic_games_dataset.olympics_data` od
JOIN Years_Table yt
ON od.Year = yt.Previous_Year
AND od.NOC = yt.NOC
WHERE Season = "Summer"
),
Previous_Gold AS (
SELECT
  NOC,
  Previous_Year,
  Season,
  COUNT(Medal) AS Previous_Gold_Count
FROM Part3_Table2 t2

WHERE Medal = "Gold"
GROUP BY Previous_Year,Season,NOC
ORDER BY Previous_Year,Season
),
-- Adding the Silver medals to the table
Previous_Silver AS (
SELECT
  NOC,
  Previous_Year,
  Season,
  COUNT(Medal) AS Previous_Silver_Count
FROM Part3_Table2 t2

WHERE Medal = "Silver"
GROUP BY Previous_Year,Season,NOC
ORDER BY Previous_Year,Season
),
-- Adding the Bronze medals to the table
Previous_Bronze AS (
SELECT
  NOC,
  Previous_Year,
  Season,
  COUNT(Medal) AS Previous_Bronze_Count
FROM Part3_Table2 t2

WHERE Medal = "Bronze"
GROUP BY Previous_Year,Season,NOC
ORDER BY Previous_Year,Season
),
-- Adding the NA medals to the table
Previous_NA AS (
SELECT
  NOC,
  Previous_Year,
  Season,
  COUNT(Medal) AS Previous_NA_Count
FROM Part3_Table2 t2

WHERE Medal = "NA"
GROUP BY Previous_Year,Season,NOC
ORDER BY Previous_Year,Season
)
SELECT
  yt.NOC,
  yt.Previous_Year,
  HG.Previous_Gold_Count,
  HS.Previous_Silver_Count,
  HB.Previous_Bronze_Count,
  HN.Previous_NA_Count
FROM Years_Table AS yt
LEFT JOIN Previous_NA AS HN
ON yt.Previous_Year = HN.Previous_Year
AND yt.NOC = HN.NOC
LEFT JOIN Previous_Bronze AS HB
ON yt.Previous_Year = HB.Previous_Year
AND yt.NOC = HB.NOC
LEFT JOIN Previous_Silver AS HS
ON yt.Previous_Year = HS.Previous_Year
AND yt.NOC = HS.NOC
LEFT JOIN Previous_Gold AS HG
ON yt.Previous_Year = HG.Previous_Year
AND yt.NOC = HG.NOC
ORDER BY Previous_Year
-- Do the Same thing but with the next year column
-- Use the find and replace to replace all "Previous" to "Next"
-- Create a view to later combine 
CREATE VIEW olympic-games-project.olympic_games_dataset.Next_Medal_Count AS
WITH Years_Table AS (
SELECT
  LAG(Year, 1) OVER (ORDER BY Year) AS Previous_Year, -- Dont change this "Previous"
  Year,
  LEAD(Year, 1) OVER (ORDER BY Year) AS Next_Year,
  NOC
FROM `olympic-games-project.olympic_games_dataset.Host_Medal_Count`
ORDER BY Year
),
Part3_Table2 AS (
SELECT
  yt.Next_Year,
  yt.Year,
  od.Year,
  

  od.NOC,
  od.Season,
  od.Medal
FROM `olympic-games-project.olympic_games_dataset.olympics_data` od
JOIN Years_Table yt
ON od.Year = yt.Next_Year
AND od.NOC = yt.NOC
WHERE Season = "Summer"
),
Next_Gold AS (
SELECT
  NOC,
  Next_Year,
  Season,
  COUNT(Medal) AS Next_Gold_Count
FROM Part3_Table2 t2

WHERE Medal = "Gold"
GROUP BY Next_Year,Season,NOC
ORDER BY Next_Year,Season
),
-- Adding the Silver medals to the table
Next_Silver AS (
SELECT
  NOC,
  Next_Year,
  Season,
  COUNT(Medal) AS Next_Silver_Count
FROM Part3_Table2 t2

WHERE Medal = "Silver"
GROUP BY Next_Year,Season,NOC
ORDER BY Next_Year,Season
),
-- Adding the Bronze medals to the table
Next_Bronze AS (
SELECT
  NOC,
  Next_Year,
  Season,
  COUNT(Medal) AS Next_Bronze_Count
FROM Part3_Table2 t2

WHERE Medal = "Bronze"
GROUP BY Next_Year,Season,NOC
ORDER BY Next_Year,Season
),
-- Adding the NA medals to the table
Next_NA AS (
SELECT
  NOC,
  Next_Year,
  Season,
  COUNT(Medal) AS Next_NA_Count
FROM Part3_Table2 t2

WHERE Medal = "NA"
GROUP BY Next_Year,Season,NOC
ORDER BY Next_Year,Season
)
SELECT
  yt.NOC,
  yt.Next_Year,
  HG.Next_Gold_Count,
  HS.Next_Silver_Count,
  HB.Next_Bronze_Count,
  HN.Next_NA_Count
FROM Years_Table AS yt
LEFT JOIN Next_NA AS HN
ON yt.Next_Year = HN.Next_Year
AND yt.NOC = HN.NOC
LEFT JOIN Next_Bronze AS HB
ON yt.Next_Year = HB.Next_Year
AND yt.NOC = HB.NOC
LEFT JOIN Next_Silver AS HS
ON yt.Next_Year = HS.Next_Year
AND yt.NOC = HS.NOC
LEFT JOIN Next_Gold AS HG
ON yt.Next_Year = HG.Next_Year
AND yt.NOC = HG.NOC
ORDER BY Next_Year

-- Combine the Host, Previous, and Next tables
SELECT *
FROM `olympic-games-project.olympic_games_dataset.Host_Medal_Count`

SELECT *
FROM `olympic-games-project.olympic_games_dataset.Previous_Medal_Count`

WITH Years_Table AS (
SELECT
  LAG(Year, 1) OVER (ORDER BY Year) AS Previous_Year,
  Year,
  LEAD(Year, 1) OVER (ORDER BY Year) AS Next_Year,
  NOC
FROM `olympic-games-project.olympic_games_dataset.Host_Medal_Count`
ORDER BY Year
)
SELECT
  yt.NOC,
  hm.Year,
  hm.Host_Gold_Count,
  hm.Host_Silver_Count,
  hm.Host_Bronze_Count,
  hm.Host_NA_Count,
  pm.Previous_Year,
  pm.Previous_Gold_Count,
  pm.Previous_Silver_Count,
  pm.Previous_Bronze_Count,
  pm.Previous_NA_Count,
  nm.Next_Year,
  nm.Next_Gold_Count,
  nm.Next_Silver_Count,
  nm.Next_Bronze_Count,
  nm.Next_NA_Count
FROM Years_Table AS yt
LEFT JOIN `olympic-games-project.olympic_games_dataset.Host_Medal_Count` AS hm
ON yt.Year = hm.Year
LEFT JOIN `olympic-games-project.olympic_games_dataset.Previous_Medal_Count` AS pm
ON yt.Previous_Year = pm.Previous_Year
LEFT JOIN `olympic-games-project.olympic_games_dataset.Next_Medal_Count` AS nm
ON yt.Next_Year = nm.Next_Year
ORDER BY yt.Year
-- Save Results for Tableau visuals

-- Convert these to percents
WITH Years_Table AS (
SELECT
  LAG(Year, 1) OVER (ORDER BY Year) AS Previous_Year,
  Year,
  LEAD(Year, 1) OVER (ORDER BY Year) AS Next_Year,
  NOC
FROM `olympic-games-project.olympic_games_dataset.Host_Medal_Count`
ORDER BY Year
)
SELECT
  yt.NOC,
  hm.Year,
  100*hm.Host_Gold_Count/(hm.Host_Gold_Count + hm.Host_Silver_Count + hm.Host_Bronze_Count + hm.Host_NA_Count) AS Host_Gold_Percent,
  100*hm.Host_Silver_Count/(hm.Host_Gold_Count + hm.Host_Silver_Count + hm.Host_Bronze_Count + hm.Host_NA_Count) AS Host_Silver_Percent,
  100*hm.Host_Bronze_Count/(hm.Host_Gold_Count + hm.Host_Silver_Count + hm.Host_Bronze_Count + hm.Host_NA_Count) AS Host_Bronze_Percent,
  100*hm.Host_NA_Count/(hm.Host_Gold_Count + hm.Host_Silver_Count + hm.Host_Bronze_Count + hm.Host_NA_Count) AS Host_NA_Percent,
  pm.Previous_Year,
  100*pm.Previous_Gold_Count/(pm.Previous_Gold_Count + pm.Previous_Silver_Count + pm.Previous_Bronze_Count + pm.Previous_NA_Count) AS Previous_Gold_Percent,
  100*pm.Previous_Silver_Count/(pm.Previous_Gold_Count + pm.Previous_Silver_Count + pm.Previous_Bronze_Count + pm.Previous_NA_Count) AS Previous_Silver_Percent,
  100*pm.Previous_Bronze_Count/(pm.Previous_Gold_Count + pm.Previous_Silver_Count + pm.Previous_Bronze_Count + pm.Previous_NA_Count) AS Previous_Bronze_Percent,
  100*pm.Previous_NA_Count/(pm.Previous_Gold_Count + pm.Previous_Silver_Count + pm.Previous_Bronze_Count + pm.Previous_NA_Count) AS Previous_NA_Percent,
  nm.Next_Year,
  100*nm.Next_Gold_Count/(nm.Next_Gold_Count + nm.Next_Silver_Count + nm.Next_Bronze_Count + nm.Next_NA_Count) AS Next_Gold_Percent,
  100*nm.Next_Silver_Count/(nm.Next_Gold_Count + nm.Next_Silver_Count + nm.Next_Bronze_Count + nm.Next_NA_Count) AS Next_Silver_Percent,
  100*nm.Next_Bronze_Count/(nm.Next_Gold_Count + nm.Next_Silver_Count + nm.Next_Bronze_Count + nm.Next_NA_Count) AS Next_Bronze_Percent,
  100*nm.Next_NA_Count/(nm.Next_Gold_Count + nm.Next_Silver_Count + nm.Next_Bronze_Count + nm.Next_NA_Count) AS Next_NA_Percent
FROM Years_Table AS yt
LEFT JOIN `olympic-games-project.olympic_games_dataset.Host_Medal_Count` AS hm
ON yt.Year = hm.Year
LEFT JOIN `olympic-games-project.olympic_games_dataset.Previous_Medal_Count` AS pm
ON yt.Previous_Year = pm.Previous_Year
LEFT JOIN `olympic-games-project.olympic_games_dataset.Next_Medal_Count` AS nm
ON yt.Next_Year = nm.Next_Year
GROUP BY yt.NOC,yt.Year,hm.Year,pm.Previous_Year,nm.Next_Year,hm.Host_Gold_Count,hm.Host_Silver_Count,hm.Host_Bronze_Count,hm.Host_NA_Count,pm.Previous_Gold_Count,pm.Previous_Silver_Count,pm.Previous_Bronze_Count,pm.Previous_NA_Count,nm.Next_Gold_Count,nm.Next_Silver_Count,nm.Next_Bronze_Count,nm.Next_NA_Count
ORDER BY yt.Year
-- Save Results for Tableau Visuals
