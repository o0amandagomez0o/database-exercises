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








