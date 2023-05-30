-- DATA EXPLORATION PROJECT

-- We will be exploring the EPL Standings Dataset and draw insights
-- First lets have a look at the data

SELECT *
FROM EplStandings;

SELECT DISTINCT(Season)
FROM EplStandings;

-- As we can see the dataset covers 22 Premier League Seasons from the 2000-2001 season to the 2021-2022 Season

-- We want to see find which club has won the most league titles since the 2000-2001 season

SELECT Team, COUNT(Team) AS TitlesWon
FROM EplStandings
WHERE FinalPosition = 1
GROUP BY Team
ORDER BY TitlesWon DESC;

-- As we can see Manchester United have won the most titles since the start of the century with 7 while Liverpool and Leicester City are tied for the least amount with 1 each.
-- We have had 6 different title winners since the start of the century

-- We want to find out which title winners accumulated the most points and which team clinched the title with the lowest points total
-- Title winners with the most points
SELECT TOP 3 Season, Team, Pts
FROM EplStandings
WHERE FinalPosition = 1
ORDER BY Pts DESC
-- Manchester city in the 2017-2018 season accumulated the most points with 100. They were famously nicknamed the centurions

-- Title winners with the least points accumulated
SELECT TOP 3 Season, Team, Pts
FROM EplStandings
WHERE FinalPosition = 1
ORDER BY Pts 
-- Manchester United have clinched the league with the fewest points (80) on two separate occassions in the 2000-2001 and 2010-2011 seasons

-- Now we want to see which clubs have suffered relegation the most since the start of the century
SELECT Team, COUNT(Team) AS Number_Of_Relegations
FROM EplStandings
WHERE Status = 'Relegated' OR Status LIKE '%Relegation%'
GROUP BY Team
ORDER BY Number_Of_Relegations DESC

-- Norwich and Westbromwich Albion have suffered the most amount of relegations with 5 while a number of clubs are tied on just 1 relegation.

-- Lets find out which club has accumulated the most number of wins since the start of the century
SELECT Team, SUM(Wins) AS Number_Of_Wins
FROM EplStandings
GROUP BY Team
ORDER BY Number_Of_Wins DESC;

-- Manchester United sits at the top with 507 wins with Chelsea and Arsenal rounding off the top 3 with 492 and 470 respectively
-- Bradford City have the least number of wins in the division with 5 with Conventry City and Blackpool making up the rest of the bottom 3 with 8 and 10 wins respectively.

-- Teams with the most losses since the start of the century
SELECT Team, SUM(Losses) AS Number_of_Losses
FROM EplStandings
GROUP BY Team
ORDER BY Number_of_Losses DESC;
-- Newcastle United have suffered with most amount of losses with 307 while Brentford have suffered the least with 18

-- Lets talk about goals now and see which teams have been the most prolific infront of goal
SELECT Team, SUM(GoalsScored) AS Goals_Scored
FROM EplStandings
GROUP BY Team
ORDER BY Goals_Scored DESC;

-- Manchester United have scored the most goals with 1562 followed closely by Arsenal who trail by only one goal
-- Bradford City have scored the least amount of goals with 30

-- Who stands at the top if all the points were added up since the start of the century?
SELECT Team, SUM(Pts) AS TotalPoints
FROM EplStandings
GROUP BY Team
ORDER BY TotalPoints DESC

-- Manchester United, Chelsea, Arsenal and Liverpool will make up the top 4 with Manchester United winning the league with 1698 points


-- Now we want to look at how each team has performed in every season and also how many seasons they have çompeted in the league.
-- We will be using a CTE

WITH TeamSeasons AS (
	SELECT Team, COUNT(DISTINCT(Season)) AS Number_of_Seasons
	FROM EplStandings
	GROUP BY Team
)
SELECT E.*, TS.Number_of_Seasons AS Seasons_in_league
FROM EplStandings AS E
JOIN TeamSeasons AS TS ON
	E.Team = TS.Team
ORDER BY Seasons_in_league DESC

-- Using a TempTable

DROP TABLE IF EXISTS #TempEplStandings
CREATE TABLE #TempEplStandings (
 Season varchar(9),
 FinalPosition INT,
 Team varchar(50),
 GamesPlayed INT,
 Wins INT,
 Draws INT,
 Losses INT,
 GoalsScored INT,
 GoalsConceded INT,
 GoalDifference INT,
 Pts INT,
 Status VARCHAR(100),
 SeasonsPlayed INT,
 );

INSERT INTO #TempEplStandings (
Season, FinalPosition, Team, GamesPlayed, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, Pts, Status
)
SELECT Season, FinalPosition, Team, GamesPlayed, Wins, Draws, Losses, GoalsScored, GoalsConceded, GoalDifference, Pts, Status
FROM EplStandings

UPDATE #TempEplStandings
SET SeasonsPlayed = (
	SELECT COUNT(DISTINCT(Season))
	FROM #TempEplStandings AS t2
	WHERE t2.Team = #TempEplStandings.Team
	);

SELECT *
FROM #TempEplStandings


-- Lets find out which teams have appeared in all 22 EPL Seasons
SELECT Team, SeasonsPlayed
FROM #TempEplStandings
WHERE SeasonsPlayed = 22
GROUP BY Team, SeasonsPlayed

-- Only 6 times have appeared in all the seasons since the start of the century

