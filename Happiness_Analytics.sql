/*A database was created for the project*/
CREATE database DataProjects;
use DataProjects;
/*A table was created to import an csv file into the database table  */

CREATE TABLE GlobalHappinessTable (
Country text,
YearCalendar int,
LifeLadder float,
PositiveAffect text, 
NegativeAffect text
);

/*I couldn't convert the original datatype with ALTER TABLE Datatype, so I found as an alternative the following path:
to convert datatype to text in order to be able to apply transformations I typed on SELECT an expression with * and renamed those columns*/
SELECT gh.PositiveAffect * 1 AS PositiveAffect, gh.NegativeAffect * 1 as NegativeAffect
FROM globalhappinesstable gh;

/*Checking out for null values using IS NULL. */ 
SELECT * 
FROM globalhappinesstable gh
WHERE gh.Country is null
OR gh.LifeLadder is null
OR gh.NegativeAffect is null
OR gh.PositiveAffect is null
OR gh.YearCalendar is null; 
/*Result: No null values had been found*/

/*Checking out for blank values in datatype string columns using TRIM(columnname)*/
SELECT *
FROM globalhappinesstable gh
WHERE TRIM(Country) = ''
OR TRIM(YearCalendar) ='' 
OR TRIM(LifeLadder) = ''
OR TRIM(PositiveAffect) = ''
OR TRIM(NegativeAffect) = ''
;
/*Result: 26 rows were detected
with missing values in columns Positive and Negative Affect*/

/*After the previous finding I tried to handle blank values by updating table and converting
 blank spaces as NULL values to standarize data*/
UPDATE globalhappinesstable
SET PositiveAffect = NULL,
	NegativeAffect = NULL
WHERE TRIM(PositiveAffect) = ''
OR TRIM(NegativeAffect) = ''
AND Country IS NOT NULL;
/*Result: Due to being detected as primary key it was not possible to update the table*/

/*Option 2: Blank values where tried to be handled by updating the table and replacing them*/
UPDATE globalhappinesstable
SET PositiveAffect = 'No data available'
WHERE TRIM(PositiveAffect) = '';
/*Result: Due to being detected as primary key it was not possible to update the table*/

/*Option 3: Blank values where handled by replacing inside the query the blank
spaces with 'Missing' and created a temporary table to use it for the happiness analysis*/
CREATE TEMPORARY TABLE GlobalHappiness
SELECT *,
       CASE WHEN TRIM(PositiveAffect) = '' THEN 'Missing' 
       ELSE PositiveAffect 
       END AS PositiveFeelings,
       CASE WHEN TRIM(NegativeAffect) = '' THEN 'Missing' 
       ELSE NegativeAffect 
       END AS NegativeFeelings
FROM globalhappinesstable;
--------------------------------------------------------------------
/*----------------------------------Exploratory Data Analysis----------------------------------*/

/*What was the level of happiness in each country in the world last year?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country 
FROM GlobalHappiness gh
WHERE YearCalendar = 2023
ORDER BY gh.LifeLadder DESC;

/*What was the level of happiness in each country in the world last year?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country 
FROM GlobalHappiness gh
WHERE YearCalendar = 2023 AND gh.Country = 'Argentina'
ORDER BY gh.LifeLadder DESC;

/* What is the evolution of happiness in Argentina registered until 2023?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina' AND gh.YearCalendar between 2006 AND 2023
ORDER BY gh.YearCalendar;

/* Which were the top five years with more happiness in Argentina?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.LifeLadder DESC
LIMIT 5;

/*When was registered the maximum levels of happiness in Argentina?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.LifeLadder DESC
LIMIT 1;

/*When was registered the minimum levels of happiness in Argentina?*/
SELECT gh.LifeLadder, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.LifeLadder 
LIMIT 1;

/*When was registered the lowest levels of positive effect in Argentina?*/
SELECT gh.PositiveAffect, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.PositiveAffect
LIMIT 1;

/*When was the year with more positive feelings in Argentina?*/
SELECT gh.PositiveAffect, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.PositiveAffect DESC
LIMIT 1;

/*When was the year with more negative thoughs and feelings in Argentina?*/
SELECT gh.NegativeAffect, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.NegativeAffect DESC
LIMIT 1;

/*When was the year with less negative thoughs and feelings in Argentina? */
SELECT gh.NegativeAffect, gh.YearCalendar, gh.Country
FROM GlobalHappiness gh
WHERE gh.Country = 'Argentina'
ORDER BY gh.NegativeAffect 
LIMIT 1;

/*--------------------------------------------------------*/
/*Drop temporary table used for analysis*/
DROP TABLE GlobalHappiness;

/*The end*/

