/*Employees Database
How much do the current managers of each department get paid, 
relative to the average salary for the department? 
Is there any department where the department manager gets paid 
less than the average salary?*/

USE employees;

-- view joined tables 
SELECT *
FROM salaries AS s 
	JOIN dept_manager AS dm
		ON dm.emp_no = s.emp_no
	JOIN employees_with_departments AS ewd
		ON ewd.dept_no = dm.dept_no
		;

-- find current managers
SELECT *
FROM dept_manager AS dm
	JOIN employees_with_departments AS ewd
		USING (emp_no)
WHERE to_date > NOW();

-- get names
SELECT CONCAT(first_name, ' ', last_name) AS 'Manager Name'
FROM dept_manager AS dm
	JOIN employees_with_departments AS ewd
		USING (emp_no)
WHERE dm.to_date > NOW(); 

-- get salaries
SELECT *
FROM salaries AS s
WHERE s.to_date > NOW();		


-- apply subquery to table and filter s.to_date
SELECT *
FROM salaries AS s 
	JOIN employees_with_departments AS ewd
		USING (emp_no)
	JOIN dept_manager AS dm
		USING (emp_no)
WHERE s.emp_no IN (
				SELECT dm.emp_no
				FROM dept_manager AS dm
					JOIN employees_with_departments AS ewd
						USING (emp_no)
				WHERE dm.to_date > NOW()
					)
AND s.to_date > NOW();

-- filter columns
SELECT dept_name, CONCAT(first_name, ' ', last_name) AS 'Manager Name', salary
FROM salaries AS s 
	JOIN employees_with_departments AS ewd
		USING (emp_no)
	JOIN dept_manager AS dm
		USING (emp_no)
WHERE s.emp_no IN (
				SELECT dm.emp_no
				FROM dept_manager AS dm
					JOIN employees_with_departments AS ewd
						USING (emp_no)
				WHERE dm.to_date > NOW()
					)
AND s.to_date > NOW();

-- filter columns
SELECT dept_name, CONCAT(first_name, ' ', last_name) AS manager_name, salary
FROM salaries AS s 
	JOIN employees_with_departments AS ewd
		USING (emp_no)
	JOIN dept_manager AS dm
		USING (emp_no)
WHERE s.emp_no IN (
				SELECT dm.emp_no
				FROM dept_manager AS dm
					JOIN employees_with_departments AS ewd
						USING (emp_no)
				WHERE dm.to_date > NOW()
					)
AND s.to_date > NOW();

-- find average salaries/dept
SELECT ROUND(avg(salary), 2)
FROM salaries AS s
	JOIN employees_with_departments AS ewd
		USING (emp_no)
WHERE s.to_date > NOW()
GROUP BY dept_no;

-- find average salaries/dept w/ dept name
SELECT ROUND(avg(salary), 2), dept_name
FROM salaries AS s
	JOIN employees_with_departments AS ewd
		ON s.emp_no = ewd.emp_no
WHERE s.to_date > NOW()
GROUP BY dept_name;

/*
-- add 2nd subquery: need to contue fixing
SELECT dept_name, CONCAT(first_name, ' ', last_name) AS manager_name, salary, ROUND(avg(salary), 2)
FROM salaries AS s 
	JOIN employees_with_departments AS ewd
		USING (emp_no)
	JOIN dept_manager AS dm
		USING (emp_no)
WHERE s.emp_no IN (
				SELECT dm.emp_no
				FROM dept_manager AS dm
					JOIN employees_with_departments AS ewd
						USING (emp_no)
				WHERE dm.to_date > NOW()
					)
AND s.to_date > NOW()
AND s.emp_no IN (
			SELECT s.emp_no
			FROM salaries AS s
				JOIN employees_with_departments AS ewd
					USING (emp_no)
			WHERE s.to_date > NOW()
			GROUP BY dept_no
				);
*/

 -- temp table....
 use easley_1261;
 
 -- create temp table
 CREATE TEMPORARY TABLE m_sal AS (
 					SELECT dept_name, CONCAT(first_name, ' ', last_name) AS manager_name, salary, ewd.dept_no
					FROM employees.salaries AS s 
						JOIN employees.employees_with_departments AS ewd
							USING (emp_no)
						JOIN employees.dept_manager AS dm
							USING (emp_no)
					WHERE s.emp_no IN (
									SELECT dm.emp_no
									FROM employees.dept_manager AS dm
										JOIN employees.employees_with_departments AS ewd
											USING (emp_no)
									WHERE dm.to_date > NOW()
										)
					AND s.to_date > NOW()
 										);
-- view table
SELECT *
FROM m_sal;


-- create 2nd temp table
CREATE TEMPORARY TABLE davgsal AS (
					SELECT ROUND(avg(salary), 2) AS depavgsal, dept_no
					FROM employees.salaries AS s
						JOIN employees.employees_with_departments AS ewd
							ON s.emp_no = ewd.emp_no
					WHERE s.to_date > NOW()
					GROUP BY dept_no
										);

-- view table
SELECT *
FROM davgsal;

-- JOIN TEMP TABLES
SELECT *
FROM m_sal
	JOIN davgsal
		USING (dept_no);

/*
-- ADD COLUMN
ALTER TABLE m_sal ADD avg_dep_sal DECIMAL(15, 2);

-- view table
SELECT *
FROM m_sal;

-- view table
SELECT depavgsal
FROM davgsal;

-- FILL IN NULLs: not working....
UPDATE m_sal SET avg_dep_sal = (
					SELECT depavgsal
					FROM davgsal
								/*'66971.35',
								'67665.62',
								'78644.91',
								'63795.02',
								'80014.69',
								'67841.95',
								'65382.06',
								'67932.71',
								'88842.16'	
									);
*/



-- ADD std COLUMN
ALTER TABLE m_sal ADD st_dev DECIMAL(15, 2);

-- VIEW JOIN TEMP TABLES
SELECT *
FROM m_sal
	JOIN davgsal
		USING (dept_no);

-- view table
SELECT std(salary)
FROM employees.salaries;


-- FILL IN NULLs
UPDATE m_sal SET st_dev = (
				SELECT std(salary)
				FROM employees.salaries
								);

-- view table
SELECT *
FROM m_sal
	JOIN davgsal
		USING (dept_no);

-- ADD zscore COLUMN
ALTER TABLE m_sal ADD zscore DECIMAL(15, 2);
		
-- create new t table
CREATE TEMPORARY TABLE tablec AS (
SELECT *
FROM m_sal
	JOIN davgsal
		USING (dept_no)
);

-- view table
SELECT *
FROM tablec;

-- FILL IN NULLs
UPDATE tablec SET zscore = (salary - depavgsal) / st_dev;

-- view table
SELECT *
FROM tablec;



/*
World Database
Use the world database for the questions below.
*/

use world;

-- 1. What languages are spoken in Santa Monica

-- create subquery
SELECT *
FROM city
WHERE ID = 4060;

-- insert subquery into  Countrylanguage
SELECT *
FROM countrylanguage
WHERE CountryCode IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 4060
						);

-- clean up columns
SELECT Language, Percentage
FROM countrylanguage
WHERE CountryCode IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 4060
						)
ORDER BY Percentage;

-- 2. How many different countries are in each region?

SELECT *
FROM country;

-- filter columns
SELECT Region, Name
FROM country;

-- count countries
SELECT Region, COUNT(Name)
FROM country
GROUP BY Region;

-- clean up
SELECT Region, COUNT(Name) AS No_of_Countries
FROM country
GROUP BY Region
ORDER BY No_of_Countries;

-- 3. What is the population for each region?

-- filter columns
SELECT Region, Population
FROM country
GROUP BY Region, Population;

-- combine duplicates by summing
SELECT Region, sum(Population)
FROM country
GROUP BY Region
ORDER BY sum(Population) DESC;

-- 4. What is the population for each continent?
SELECT Continent, sum(Population)
FROM country
GROUP BY continent
ORDER BY sum(Population) DESC;

-- 5. What is the average life expectancy globally?
SELECT *
FROM country; 

-- life exp
SELECT LifeExpectancy
FROM country; 

-- avg(life exp)
SELECT avg(LifeExpectancy)
FROM country; 

-- 6. What is the average life expectancy for each region, each continent? Sort the results from shortest to longest


-- avg life expectancy for each continent
SELECT Continent, avg(LifeExpectancy) AS life_expectancy
FROM country
GROUP BY Continent
ORDER BY life_expectancy;



-- avg life expectancy for each region
SELECT Region, LifeExpectancy
FROM country;

-- AVG
SELECT Region, avg(LifeExpectancy)
FROM country
GROUP BY R;

-- AVG, clean up
SELECT Region, avg(LifeExpectancy) AS life_expectancy
FROM country
GROUP BY Region
ORDER BY life_expectancy;


/*
Bonus
*/

-- 7. Find all the countries whose local name is different from the official name
SELECT *
FROM country; 

-- filter column
SELECT name, LocalName
FROM country; 

-- where
SELECT name, LocalName
FROM country
WHERE name <> LocalName;

-- 8. How many countries have a life expectancy less than OSAKA?
SELECT Name, LifeExpectancy
FROM country;

-- join 2 tables
SELECT *
FROM country
	JOIN city
		ON city.CountryCode = country.code;
		
-- filter columns
SELECT country.Name, LifeExpectancy
FROM country
	JOIN city
		ON city.CountryCode = country.code;		

-- create subquery
SELECT LifeExpectancy
FROM country 
WHERE Code IN (
				SELECT CountryCode
				FROM city
				WHERE ID = 1534);	
						
-- insert subquery
SELECT country.Name, country.Continent, LifeExpectancy
FROM country
	JOIN city
		ON city.CountryCode = country.code
WHERE LifeExpectancy > (
						SELECT LifeExpectancy
						FROM country 
						WHERE Code IN (
									SELECT CountryCode
									FROM city
									WHERE ID = 1534
										)
						);	
						

-- 9. What state is OSAKA located in?
SELECT *
FROM city;

-- specify city ID
SELECT *
FROM city
WHERE ID = 1534;	

-- filter columns
SELECT District
FROM city
WHERE ID = 1534;	



-- 10. What region of the world is OSAKA located in?
SELECT *
FROM country
	JOIN city 
		ON city.CountryCode = country.code
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
);	

-- FILTER COLUMNS
SELECT Region
FROM country
	JOIN city 
		ON city.CountryCode = country.code
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
);	

-- group by
SELECT Region
FROM country
	JOIN city 
		ON city.CountryCode = country.code
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
)
GROUP BY Region;	


-- 11. What country (use the human readable name) OSAKA located in?
-- view table
SELECT *
FROM country;

-- view table
SELECT *
FROM city;

-- merge 2 tables
SELECT *
FROM country
	JOIN city 
		ON city.CountryCode = country.code;
		
-- filter columns
SELECT country.Name
FROM country
	JOIN city 
		ON city.CountryCode = country.code;	
		
-- insert subquery
SELECT country.Name
FROM country
	JOIN city 
		ON city.CountryCode = country.code
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
);	

-- group by
SELECT country.Name
FROM country
	JOIN city 
		ON city.CountryCode = country.code
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
)
GROUP BY Name;					


-- 12. What is the life expectancy in OSAKA? 
-- 80.7
SELECT *
FROM city
WHERE ID = 1534;

-- insert subquery
SELECT LifeExpectancy
FROM country 
WHERE Code IN (
			SELECT CountryCode
			FROM city
			WHERE ID = 1534
);


/*

Sakila Database

*/

-- 1. Display the first and last names in all lowercase of all the actors.
SELECT *
FROM actor;

-- filter columns
SELECT LOWER(first_name), LOWER(last_name)
FROM actor;

-- Combine into one column
-- filter columns
SELECT CONCAT(LOWER(first_name), ' ', LOWER(last_name)) AS Actor_Name
FROM actor;

/*
--  2.You need to find the 
		ID number, 
		first name, and 
		last name of an actor, 
	of whom you know only the first name, "Joe." 
What is one query would you could use to obtain this information? */
SELECT * 
FROM actor;

-- filter columns
SELECT actor_id, first_name, last_name
FROM actor;

-- filter for Joe
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';


-- 3.Find all actors whose last name contain the letters "gen":

SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor
WHERE last_name LIKE '%gen%';

-- 4.Find all actors whose last names contain the letters "li". This time, order the rows by last name and first name, in that order.
SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor
WHERE last_name LIKE '%li%';

-- addr the order request
SELECT CONCAT(first_name, ' ', last_name) AS Actor_Name
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;

-- 5.Using IN, display the country_id and country columns for the following countries: Afghanistan, Bangladesh, and China:
SELECT *
FROM country;

-- filter columns
SELECT country_id, country
FROM country;

-- filter rows
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');


-- 6.List the last names of all the actors, as well as how many actors have that last name.
SELECT *
FROM actor;

-- filter columns
SELECT last_name
FROM actor;

-- add count, group by necessary
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;


-- 7.List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;

-- CLEAN
SELECT last_name, count(last_name) AS No_Actors
FROM actor
GROUP BY last_name
ORDER BY No_Actors DESC;

-- COMBINE AS A SUBQUERY
SELECT last_name, count(last_name) AS No_Actors
FROM actor
GROUP BY last_name
HAVING No_Actors > 1
ORDER BY No_Actors DESC;


-- 8.You cannot locate the schema of the address table. Which query would you use to re-create it?
SELECT *
FROM address;

-- Unknown storage engine 'sakila'
ALTER TABLE address ENGINE = sakila;

-- 
SELECT 
  `address_SCHEMA`,                          -- Foreign key schema
  `address_NAME`,                            -- Foreign key table
  `COLUMN_NAME`,                           -- Foreign key column
  `REFERENCED_TABLE_SCHEMA`,               -- Origin key schema
  `REFERENCED_TABLE_NAME`,                 -- Origin key table
  `REFERENCED_COLUMN_NAME`                 -- Origin key column
FROM
  `INFORMATION_SCHEMA`.`KEY_COLUMN_USAGE`  -- Will fail if user don't have privilege
WHERE
  `TABLE_SCHEMA` = SCHEMA()                -- Detect current schema in USE 
  AND `REFERENCED_TABLE_NAME` IS NOT NULL; -- Only tables with foreign keys

-- INSERT command denied to user 'easley_1261'@'104-190-255-174.lightspeed.snantx.sbcglobal.net' for table 'address'
REPAIR TABLE address;



-- 9. Use JOIN to display the first and last names, as well as the address, of each staff member.
-- view table to join
SELECT *
FROM staff;

-- view table to join
SELECT *
FROM address;

-- join
SELECT *
FROM staff
	JOIN address 
		USING (address_id);
		
-- filter columns
SELECT first_name, last_name, address
FROM staff
	JOIN address 
		USING (address_id);		

-- clean table
SELECT CONCAT(first_name, ' ', last_name) AS Employee_Name, address
FROM staff
	JOIN address 
		USING (address_id);	


-- 10. Use JOIN to display the total amount rung up by each staff member in August of 2005.
-- 
SELECT *
FROM sales_by_store;

-- 
SELECT *
FROM staff;

-- view table
SELECT *
FROM payment;

-- filter dates
SELECT *
FROM payment
WHERE payment_date LIKE '2005-08-%';

-- filter dates
SELECT *
FROM payment
	JOIN staff
		USING (staff_id)
WHERE payment_date LIKE '2005-08-%';

-- filter columns
SELECT CONCAT(first_name, " ", last_name) AS Emp_Name, amount
FROM payment
	JOIN staff
		USING (staff_id)
WHERE payment_date LIKE '2005-08-%';

-- group by
SELECT CONCAT(first_name, " ", last_name) AS Emp_Name, sum(amount)
FROM payment
	JOIN staff
		USING (staff_id)
WHERE payment_date LIKE '2005-08-%'
GROUP BY Emp_Name;

-- group by
SELECT CONCAT(first_name, " ", last_name) AS Emp_Name, sum(amount) AS Total_Aug_Sales
FROM payment
	JOIN staff
		USING (staff_id)
WHERE payment_date LIKE '2005-08-%'
GROUP BY Emp_Name;


-- 11.List each film and the number of actors who are listed for that film.


-- 12.How many copies of the film Hunchback Impossible exist in the inventory system?


-- 13.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.


-- 14.Use subqueries to display all actors who appear in the film Alone Trip.


-- 15.You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.


-- 16.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.


-- 17.Write a query to display how much business, in dollars, each store brought in.


-- 18.Write a query to display for each store its store ID, city, and country.


-- 19.List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)




