
-- What languages are spoken in the United States? (12) Brazil? (not Spanish...) Switzerland? (6)
SELECT
    code,
    name,
    COUNT (language)
FROM
  country ctry JOIN
    countrylanguage lang ON (countrycode = code)
GROUP BY
	name,
    code
ORDER BY
	name DESC

-- What are the official languages of Switzerland? (4 languages)

SELECT
    code,
    name,
   	language,
    lang.isofficial
FROM
  country ctry JOIN
    countrylanguage lang ON (countrycode = code)
WHERE
	name like 'Switzerland'


-- Which country or countries speak the most languages? (12 languages)
  SELECT
    code,
    name,
   	COUNT (language) as num_of_lang
FROM
  country ctry JOIN
    countrylanguage lang ON (countrycode = code)
GROUP BY
	ctry.code
ORDER BY
	num_of_lang DESC

-- Which country or countries have the most official languages? (4 languages)
SELECT
    code,
    name,
   	COUNT (language) as num_of_lang
FROM
  country ctry JOIN
    countrylanguage lang ON (countrycode = code)
WHERE
	lang.isofficial = true
GROUP BY
	ctry.code
ORDER BY
	num_of_lang DESC

  -- Which languages are spoken in the ten largest (area) countries?

  WITH
  	country_big AS
      	(SELECT
           	code,
               name,
               surfacearea
           FROM
           	country
           ORDER BY
           	surfacearea DESC
           LIMIT 10
          )
  SELECT
      code,
      name,
     	language,
  	surfacearea
  FROM
    country_big ctry JOIN
      countrylanguage lang ON (countrycode = code)
  ORDER BY
  	surfacearea DESC

  -- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)

  WITH
	country_poor AS
    	(SELECT
         	code,
            name,
            ((gnp / population)*1000000) AS gnp_cap
         FROM
         	country
         WHERE
         	population > 0 AND
         	gnp > 0
         ORDER BY
         	gnp_cap ASC
         LIMIT 20
        )
SELECT
    code,
    name,
   	language,
	gnp_cap
FROM
  country_poor ctry JOIN
    countrylanguage lang ON (countrycode = code)
ORDER BY
	gnp_cap ASC

  
