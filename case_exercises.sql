SELECT n,
CASE
	WHEN n = 3 then n+100
	ELSE n
	END AS output
FROM numbers;

use easley_1261;


create temporary table example AS (
	SELECT dept_name, IF(dept_name = 'Research', true, false) AS is_research
	FROM employees.departments
);

select *
from example;

select avg(is_research)
from example;

-- Create a file named case_exercises.sql and craft queries to return the results for the following criteria:

-- 1. Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.
use employees;


-- view joined tables
SELECT * 
# emp_no, dept_no, hire_date, to_date
FROM dept_emp AS de
	JOIN employees AS e
		USING (emp_no);

-- pull needed columns
SELECT 
	emp_no, 
	dept_no, 
	hire_date, 
	to_date
FROM dept_emp AS de
	JOIN employees AS e
		USING (emp_no);
		
-- insert CASE
SELECT 
	emp_no, 
	dept_no, 
	hire_date, 
	to_date,
	IF(to_date > NOW(), true, false) AS is_current_employee 
FROM dept_emp AS de
	JOIN employees AS e
		USING (emp_no);		



-- 2. Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.

-- view table
SELECT *
FROM employees;

-- concat the name and filter columns
SELECT CONCAT(first_name, ' ', last_name) AS emp_name
FROM employees;

-- insert case TEST with A
SELECT 
	CONCAT(first_name, ' ', last_name) AS emp_name,
	CASE 
		WHEN last_name LIKE 'A%' THEN 'A-H'
		ELSE last_name
		END AS alpha_group
FROM employees
ORDER BY last_name, first_name;

-- insert A-H CASE
SELECT 
	CONCAT(first_name, ' ', last_name) AS emp_name,
	CASE 
		WHEN last_name LIKE 'A%' 
			OR 
			last_name LIKE 'B%'
			OR 
			last_name LIKE 'C%' 
			OR 
			last_name LIKE 'D%' 
			OR 
			last_name LIKE 'E%' 
			OR 
			last_name LIKE 'F%' 
			OR 
			last_name LIKE 'G%' 
			OR 
			last_name LIKE 'H%'  
				THEN 'A-H'
		ELSE last_name
		END AS alpha_group
FROM employees
ORDER BY last_name, first_name;

-- insert I-Q CASE
SELECT 
	CONCAT(first_name, ' ', last_name) AS emp_name,
	CASE 
		WHEN last_name LIKE 'A%' 
			OR 
			last_name LIKE 'B%'
			OR 
			last_name LIKE 'C%' 
			OR 
			last_name LIKE 'D%' 
			OR 
			last_name LIKE 'E%' 
			OR 
			last_name LIKE 'F%' 
			OR 
			last_name LIKE 'G%' 
			OR 
			last_name LIKE 'H%'  
				THEN 'A-H'
				
		WHEN last_name REGEXP'^(I|J|K|L|M|N|O|P|Q)' 
				THEN 'I-Q'
				
		WHEN last_name REGEXP'^(R|S|T|U|V|W|X|Y|Z)'
				THEN 'R-Z'
				
		ELSE last_name
		END AS alpha_group
		
FROM employees
ORDER BY last_name, first_name;


-- 3. How many employees (current or previous) were born in each decade?

-- view table
SELECT *
FROM employees;

-- filter columns
SELECT 
	CONCAT(first_name, ' ', last_name) AS emp_name,
	birth_date
FROM employees;

-- try first case & added second case
SELECT 
	CONCAT(first_name, ' ', last_name) AS emp_name,
	birth_date,
	CASE 
		WHEN birth_date LIKE '195%'
			THEN 'Atomic Boomer'
		WHEN birth_date LIKE '196%'
			THEN 'Flower Child'
		ELSE birth_date
		END AS birth_decade
FROM employees
ORDER BY birth_date, last_name, first_name;







/*BONUS

What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
*/








