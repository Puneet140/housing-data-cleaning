CREATE DATABASE housing_project;
USE housing_project;

CREATE TABLE housing_raw
(
id INT,
address VARCHAR(255),
city VARCHAR(100),
state VARCHAR(10),
price INT,
bedroom INT,
bathrooms INT,
area_sqft INT,
listing_date DATE,
agent_name VARCHAR(255),
email VARCHAR(255)
);


SELECT * FROM housing_raw;

-- Now Cleaning the Data

-- Turning off safe mode:
SET SQL_SAFE_UPDATES = 0;

-- Fixing spelling Error:

SELECT city FROM housing_raw
WHERE city LIKE '%los%' OR city LIKE '%san%' OR city LIKE 'h%' OR city LIKE 'Phoenix' OR city LIKE '%NEW%';

SELECT city FROM housing_raw
WHERE city LIKE  'Phoenix' OR city LIKE '%NEW%';

UPDATE housing_raw
SET city = 'San Francisco'
WHERE city IN ('San Fransico', 'San Francsico', 'san francisco');

UPDATE housing_raw
SET city = 'Los Angeles'
WHERE city LIKE '%los%';

-- Deleting where Price <10000 or area_sqft is NULL

SELECT price,area_sqft FROM housing_raw
WHERE price<=10000 OR area_sqft IS NULL;

DELETE FROM housing_raw
WHERE price <= 10000 OR area_sqft IS NULL;

-- Removing agents with Invalid E-Mails

SELECT email FROM housing_raw
WHERE email NOT LIKE '%@%.%';

DELETE FROM housing_raw
WHERE email NOT LIKE '%@%.%';

-- Standardize Text

UPDATE housing_raw
SET city = TRIM(city),
    agent_name = TRIM(agent_name);
    
    
-- Normalizing Data

UPDATE housing_raw
SET city = CONCAT(UCASE(LEFT(city, 1)), LCASE(SUBSTRING(city, 2)));


-- Duplicates 

SELECT address, COUNT(*)
FROM housing_raw
GROUP BY address
HAVING COUNT(*) > 1;


-- Adding new column
ALTER TABLE housing_raw ADD price_per_sqft DECIMAL(10,2);
 

UPDATE housing_raw
SET price_per_sqft = price / area_sqft;

SELECT * FROM housing_raw;




