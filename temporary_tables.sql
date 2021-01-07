-- Create a file named temporary_tables.sql to do your work for this exercise.

-- 1. Using the example from the lesson, re-create the employees_with_departments table.

-- use my DB
USE easley_1261;

-- create my subquery to call EWD
SELECT *
FROM employees.employees_with_departments;

-- Create a TEMP table
CREATE TEMPORARY TABLE temp_ewd AS (
						SELECT *
						FROM employees.employees_with_departments
									);

-- call that table to view
SELECT *
FROM temp_ewd;



-- 1.a) Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns

-- use ALTER TABLE & ADD to put in another column
ALTER TABLE temp_ewd ADD full_name VARCHAR(100);

-- call the altered table to view
SELECT *
FROM temp_ewd; -- the full_name colmun is NULL b'c we have not updated.

-- 1.b) Update the table so that full name column contains the correct data

-- run UPDATE & SET data
UPDATE temp_ewd
SET full_name = CONCAT(first_name, ' ', last_name);

-- view updated table
SELECT *
FROM temp_ewd; # now full_name column is populating correctly.



-- 1.c) Remove the first_name and last_name columns from the table.

-- remove first_name column using ALTER TABLE & DROP COLUMN
ALTER TABLE temp_ewd DROP COLUMN first_name;

-- view updated table
SELECT *
FROM temp_ewd; # the 2nd column is now gone

-- remove last_name column using ALTER TABLE & DROP COLUMN
ALTER TABLE temp_ewd DROP COLUMN last_name;

-- view updated table
SELECT *
FROM temp_ewd; # the 3rd column is now gone




-- 1.d) What is another way you could have ended up with this same table?

-- I could simple adj the SELECT from * (all columns) to call for certain columns
CREATE TEMPORARY TABLE temp_ewd002 AS (
						SELECT emp_no, dept_no, dept_name, CONCAT(first_name, ' ', last_name) AS full_name 
						FROM employees.employees_with_departments
									);

-- call that table to view
SELECT *
FROM temp_ewd002;



-- 2. Create a temporary table based on the payment table from the sakila database.

-- create my subquery
SELECT *
FROM sakila.payment;

-- create my TEMP table
CREATE TEMPORARY TABLE temp_pymt AS (
						SELECT *
						FROM sakila.payment
								);

-- view updated table
SELECT *
FROM temp_pymt;


-- 2.a) Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.

-- add new column
ALTER TABLE temp_pymt ADD cents_amt INT;

-- view updated table
SELECT *
FROM temp_pymt;

-- fix the NULLs
UPDATE temp_pymt SET cents_amt = amount *100;

-- view updated table
SELECT *
FROM temp_pymt;


-- 3. Find out how the current average pay in each department compares to the overall, historical average pay. In order to make the comparison easier, you should use the Z-score for salaries. In terms of salary, what is the best department right now to work for? The worst?

-- create subquery
SELECT *
FROM employees.salaries
	JOIN employees.employees_with_departments 
		USING(emp_no);

-- create temp table for current pay
CREATE TEMPORARY TABLE c_tempsewd AS (
										SELECT *
										FROM employees.salaries
											JOIN employees.employees_with_departments 
												USING(emp_no)
										WHERE employees.salaries.to_date > NOW()
											);

-- create temp table for historical pay
CREATE TEMPORARY TABLE h_tempsewd AS (
										SELECT *
										FROM employees.salaries
											JOIN employees.employees_with_departments 
												USING(emp_no)
											);
											
-- create temp table for z-score
CREATE TEMPORARY TABLE z_tempsewd AS (
										SELECT dept_name, ROUND(avg(salary), 2) AS havg_pay
										FROM employees.salaries
											JOIN employees.employees_with_departments 
												USING(emp_no)
										GROUP BY dept_name
											);											
											

-- view newly created tables
SELECT *
FROM h_tempsewd;

SELECT *
FROM c_tempsewd;

SELECT *
FROM z_tempsewd;


/*
-- adj table to produce only the 9 depts
SELECT dept_name, ROUND(avg(salary), 2) AS 'Historical avg_pay', stddev(salary)
FROM h_tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;

SELECT dept_name, ROUND(avg(salary), 2) AS 'Current avg_pay', stddev(salary)
FROM c_tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;

SELECT ROUND(salary - avg(salary)) / stddev(salary)) AS 'z-score'
FROM z_tempsewd;
*/


/*
-- adj table to produce only the 9 depts
SELECT dept_name, ROUND(avg(salary), 2) AS 'Current avg_pay', ROUND((sum(salary) - avg(salary)) / stddev(salary)) AS 'z-score'
FROM tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;


-- zscore formula
(() - ()) / stddev();

-- copy/paste
(
	(
	SELECT ROUND(avg(salary), 2) AS 'Current avg_pay'
	FROM c_tempsewd
	GROUP BY dept_name
	ORDER BY avg(salary) DESC
	) 
- 
	(
	SELECT ROUND(avg(salary), 2) AS 'Historical avg_pay'
	FROM h_tempsewd
	)
) 
/ 
	(
	SELECT stddev(salary)
	FROM h_tempsewd

	);

-- insert with SELECT: creates error: Can't reopen table: 'h_tempsewd'
SELECT 
(
(
	(
	SELECT salary
	FROM h_tempsewd
	GROUP BY dept_name
	ORDER BY avg(salary) DESC
	) 
- 
	(
	SELECT ROUND(avg(salary), 2)
	FROM h_tempsewd
	GROUP BY dept_name
	ORDER BY avg(salary) DESC
	)
) 
/ 
	(
	SELECT stddev(salary)
	FROM h_tempsewd
	GROUP BY dept_name
	ORDER BY avg(salary) DESC
	)
);
*/




-- find mu & sigma!!
-- mu: 63805.40
-- sigma: 16900.85
SELECT ROUND(avg(salary), 2), ROUND(stddev(salary), 2)
FROM easley_1261.h_tempsewd;


-- view FULL temp tables to see what can be removed
SELECT *
FROM z_tempsewd;


/*
-- remove uneccessary columns
ALTER TABLE z_tempsewd DROP COLUMN emp_no,
						DROP COLUMN from_date,
						DROP COLUMN first_name, 
						DROP COLUMN last_name,
						DROP COLUMN dept_no,
						DROP COLUMN to_date;
*/


-- add stddev column
ALTER TABLE z_tempsewd ADD totalstddev DECIMAL(15, 2);

UPDATE z_tempsewd SET totalstddev = (
									SELECT ROUND(stddev(salary), 2)
									FROM easley_1261.h_tempsewd
									);

-- add hist avg pay column
ALTER TABLE z_tempsewd ADD totavgpay DECIMAL(15, 2);

UPDATE z_tempsewd SET totavgpay = (
									SELECT ROUND(avg(salary), 2)
									FROM easley_1261.h_tempsewd
									);

-- add zscore column
ALTER TABLE z_tempsewd ADD zscore DECIMAL(15, 2);

UPDATE z_tempsewd SET zscore = (havg_pay - totavgpay) / totalstddev;



/*
-- group by depts
SELECT dept_name, ROUND(avg(salary), 2) AS 'Historical avg_pay'
FROM z_tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;

-- 
SELECT dept_name, ROUND(avg(salary), 2) AS 'Historical avg_pay', ((ROUND(avg(salary), 2)) - totavgpay) / totalstddev
FROM z_tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;



-- Let's try the HISTORICAL data
SELECT dept_name, ROUND(avg(salary), 2) AS 'Historical avg_pay', stddev(salary)
FROM h_tempsewd
GROUP BY dept_name
ORDER BY avg(salary) DESC;
*/
