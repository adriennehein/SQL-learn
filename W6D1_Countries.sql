-- WHERE

-- What is the population of the US?
SELECT population FROM country WHERE (code = 'USA');
-- What is the area of the US?
SELECT surfacearea FROM country WHERE (code = 'USA');
-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45?
SELECT continent, code, population, lifeexpectancy  FROM country WHERE population < 3e+7 AND continent = 'Africa' AND lifeexpectancy > 45;
-- Which countries are something like a republic?
SELECT * FROM country WHERE governmentform IN ('Republic');
-- Which countries are some kind of republic and acheived independence after 1945?
SELECT * FROM country WHERE governmentform IN ('Republic') AND indepyear > 1945;
-- Which countries acheived independence after 1945 and are not some kind of republic?
SELECT * FROM country WHERE indepyear > 1945 AND governmentform NOT IN ('Republic', 'Federal Republic', 'Socialistic Republic', 'Islamic Republic');

-- ORDER BY
-- Which fifteen countries have the lowest life expectancy? highest life expectancy?
WITH life_expected AS (SELECT * FROM country WHERE lifeexpectancy IS NOT NULL) SELECT * FROM life_expected ORDER BY lifeexpectancy DESC LIMIT 15;
-- Which five countries have the lowest population density? highest population density?
SELECT * , population / surfacearea AS pop_density FROM country ORDER BY pop_density ASC;
-- Which is the smallest country, by area and population? the 10 smallest countries, by area and population?
-- Which is the biggest country, by area and population? the 10 biggest countries, by area and population?
SELECT * FROM country ORDER BY (surfacearea, population) ASC LIMIT 10;

-- WITH
-- Of the smallest 10 countries, which has the biggest gnp?
WITH small_countries AS (SELECT * FROM country ORDER BY surfacearea ASC LIMIT 10) SELECT * FROM small_countries ORDER BY gnp DESC;
-- Of the smallest 10 countries, which has the biggest per capita gnp?
WITH small_countries AS (SELECT population, gnp, surfacearea, gnp / population AS per_capita FROM country WHERE population > 0 AND gnp > 0 ORDER BY surfacearea ASC LIMIT 10) SELECT population, gnp, surfacearea, gnp / population AS per_capita FROM small_countries ORDER BY gnp / population ASC;
-- Of the biggest 10 countries, which has the biggest gnp?
WITH big_countries AS (SELECT population, gnp, surfacearea, gnp / population AS per_capita FROM country WHERE population > 0 AND gnp > 0 ORDER BY surfacearea DESC LIMIT 10) SELECT population, gnp, surfacearea, gnp / population AS per_capita FROM big_countries ORDER BY gnp / population DESC;
-- Of the biggest 10 countries, which has the biggest per capita gnp?
WITH big_countries AS (SELECT surfacearea, code FROM country ORDER BY surfacearea DESC LIMIT 10) SELECT sum(big_countries.surfacearea) FROM big_countries;
-- What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?
WITH small_countries AS (SELECT surfacearea, code FROM country ORDER BY surfacearea ASC LIMIT 10)
SELECT sum(small_countries.surfacearea) FROM small_countries;

-- GROUP BY
-- How big are the continents in term of area and population?
SELECT continent, avg(country.surfacearea) AS total_area, avg(country.population) AS total_pop FROM country GROUP BY continent;
-- Which region has the highest average gnp?
SELECT region, avg(country.gnp) AS reg_average FROM country GROUP BY region ORDER BY reg_average DESC;
-- Who is the most influential head of state measured by population?
SELECT headofstate, region, max(country.population) AS max_pop FROM country GROUP BY region, headofstate ORDER BY max_pop DESC;
-- Who is the most influential head of state measured by surface area?
SELECT headofstate, region, max(country.surfacearea) AS max_area FROM country GROUP BY region, headofstate ORDER BY max_area DESC;
-- What are the most common forms of government?
SELECT governmentform, count(country.governmentform) AS gov_count FROM country GROUP BY governmentform ORDER BY gov_count DESC;
-- What are the forms of government for the top ten countries by surface area?
WITH big_area AS (SELECT surfacearea, governmentform FROM country ORDER BY surfacearea DESC LIMIT 10)
SELECT governmentform, count(big_area.governmentform) AS gov_count FROM big_area GROUP BY governmentform ORDER BY gov_count DESC;
-- What are the forms of government for the top ten richest nations? (technically most productive)
WITH big_money AS (SELECT gnp, governmentform FROM country ORDER BY gnp DESC LIMIT 10)
SELECT governmentform, count(big_money.governmentform) AS gov_count FROM big_money GROUP BY governmentform ORDER BY gov_count DESC;
-- What are the forms of government for the top ten richest per capita nations? (technically most productive)
WITH big_money AS (SELECT gnp, population, governmentform, gnp / population AS per_capita FROM country WHERE (population > 0) ORDER BY per_capita DESC LIMIT 10)
SELECT governmentform, count(big_money.governmentform) AS gov_count FROM big_money GROUP BY governmentform ORDER BY gov_count DESC;


-- Stretch Challenges
-- What is the 3rd most common language spoken?
SELECT language, count(countrylanguage.language) FROM countrylanguage GROUP BY language ORDER BY count DESC
-- How many cities are in Chile?
WITH chile AS (SELECT * FROM city WHERE countrycode = 'CHL')
SELECT countrycode, count(chile.id) FROM chile GROUP BY countrycode
-- What is the total population in China?
SELECT population, name FROM country WHERE name = 'China'
-- How many countries are in North America?
select count(country.name) from country where continent = 'North America'
-- Which countries gained their independence before 1963?
SELECT indepyear, name FROM country WHERE indepyear < 1963 ORDER BY indepyear ASC
-- What is the total population of all continents?
SELECT continent, SUM(country.population) AS total_pop FROM country GROUP BY continent;
-- What is the average life expectancy for all continents?
SELECT continent, AVG(country.lifeexpectancy) AS avg_life FROM country GROUP BY continent;
-- Which countries are in the top 5% in terms of area?
SELECT * FROM country ORDER BY surfacearea DESC
LIMIT (SELECT (COUNT(*) * .05) AS percentile FROM country)
-- Which countries have the letter z in the name? How many?
SELECT name FROM country WHERE name LIKE '%z%' OR name LIKE 'Z%'
-- What is the age of Jamaica?
SELECT (2018-country.indepyear) FROM country WHERE name ='Jamaica'
-- Are there any countries without an official language?
SELECT countrycode, SUM(countrylanguage.isofficial::int) FROM countrylanguage GROUP BY countrycode ORDER BY sum ASC;
