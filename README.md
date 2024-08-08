# Data Analyst Portfolio

## Table of Contents
- [About Me](https://justincarder.github.io/portfolio/#about-me)
- [Education](https://justincarder.github.io/portfolio/#education)
- [Certificates](https://justincarder.github.io/portfolio/#certificates)
- [Experience](https://justincarder.github.io/portfolio/#experience)
- [Projects](https://justincarder.github.io/portfolio/#projects)
- [Contact Information](https://justincarder.github.io/portfolio/#contact-information)

## About Me 
Hello! I am Justin, a passionate data analyst with a background in Mechanical Engineering and a keen interest in uncovering insights and driving decision-making through data. With a strong foundation in statistics, data visualization, and programming, I strive to transform complex data into useful and impactful solutions. My resume is attached [here](https://github.com/JustinCarder/portfolio/blob/main/Olympic_Games_Project.sql).

## Education
Johns Hopkins University: Bachelor of Science - Mechanical Engineering, Aug 2019 - May 2023

## Certificates
[Google Data Analystics Professional Certificate](https://www.coursera.org/professional-certificates/google-data-analytics#courses)

Skills: SQL, R, Excel/Spreadsheets, Tableau, Data Analysis Process
## Experience
JHU Senior Design Project, Aug 2022 - May 2023
- Provide a blind-accessible solution for Blind Industries and Services of Maryland’s (BISM) shortage of straight white canes for their rehabilitation associates. Preformed tests, collected large amounts of data, cleaned/analyzed the data using Excel, and used the data to communicate to stakeholders and improve our designs.

## Projects

### SQL Project: Olympic Games 1896-2016
**Description:** The following dataset from Kaggle was used for this project [120 Years of Olympic history: athletes and results.](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results/data) This project focused on analyzing a dataset on the Olympic Games between 1896 and 2016. The dataset consisted of each athlete's ID, Name, Sex, Age, Height, Weight, Team, Sport, Event, and Medal along with the Games, Year, Season, and City of the games they participated in. The project involved cleaning, manipulating, analyzing the data in SQL and then creating visuals of the analysis in Tableau.
- **Part 1:** Looking at how the average weight, height, and age of medalists have changed overtime and their correlations with time for each sport in the Olympics
- **Part 2:** Looking at how the average weight, height, and age of each medalist (Gold, Silver, Bronze, Non-Medalist) compare for each sport. Also, compare the body metrics of gold medalists between two sports.
- **Part 3:** Looking at if hosting the Olympic Games impacts how well the host country performs that year by comparing their medal counts/percentages from the games prior and after their host year

**Code 1:** [Olympic Games SQL Code: Body Measurements Overtime](https://github.com/JustinCarder/portfolio/blob/main/Olympic_Games_Project.sql)

**Results 1:** [Olympic Games Tableau Dashboard](https://public.tableau.com/shared/JSZGP8XXM?:display_count=n&:origin=viz_share_link)

**Conclusion 1:** Using the sliders on the bottom right, for male the highest correlation for Weight-Year, Height-Year, and Age-Year are baseball, curling, and table tennis respectively. For female, the highest negative correlation for Weight-Year, Height-Year, and Age-Year are gymnastics, bobsleigh, and archery respectively.

**Code 2:** [Olympic Games SQL Code: Body Measurements Per Medal Comparison](https://github.com/JustinCarder/portfolio/blob/main/Body_Measurements_Per_Medal.sql)

**Results 2:** [Olympic Games Tableau Dashboard](https://public.tableau.com/views/OlympicGamesProject2/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

**Conclusion 2:** Two examples of conclusions are that in gymnastics, height and weight decrease the higher the medal but age increased for both sexes. Also, male volleyballers had higher ages, weights, and heights the higher the medal, but the only metric that changed with female volleyballers signifcantly was weight which increased.

**Code 3:** [Olympic Games SQL Code: Effects of Hosting the Olympics](https://github.com/JustinCarder/portfolio/blob/main/olympic_games_host_project.sql)

**Results 3:** [Olympic Games Tableau Dashboard](https://public.tableau.com/shared/WZGQYQDRR?:display_count=n&:origin=viz_share_link)

**Conclusion 3:** Watching the video of the medal count on the world map, one can see the countries are darkest in shade during the host year which means they had the highest medal counts then. Also looking at the table, adding up all of the medals for each year one can find that the percentage of medalist was 22%, 25%, and 23% respectively. This means that there is a slight increase in performance for the country who hosts.

### Python Project: Comparing Movie Attributes 
**Description:** The following dataset was used for this project [Movies Data.](https://github.com/JustinCarder/portfolio/blob/main/movies.csv) This project focused on analyzing a dataset on movies. The dataset consisted of a list of movies with their name, rating, genre, year, released, score, votes, director, writer, star, country, budget, gross, company, and runtime. The project involved cleaning data, manipulating data, analyzing, and creating visuals in python using pandas, seasborn, and numpy. The project also looked for correlations between different variables.

**Code/Results:** [Movie Correlations Python Jupyter Notebook](https://github.com/JustinCarder/portfolio/blob/main/MoviesProject.ipynb)

**Conclusion:** The highest positive correlation between two variables was budget and gross of 0.74, meaning that as budget increased the gross revenue of the movie also increased. The highest negative correlation between two variables was genre and budget of -0.37. The two variables that had almost no correlation was runtime and released date.

### R Project:
**Descriptioin:** TBD

**Code:** TBD

**Results:** TBD

## Contact Information
- Email: justincarder24@yahoo.com
- LinkedIn: www.linkedin.com/in/justin-carder
