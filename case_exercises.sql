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

		
-- insert CASE: 331603 rows is more than actual hired employees b'c employees changed depts and created duplicates
SELECT 
	emp_no, 
	dept_no, 
	hire_date, 
	to_date,
	IF(to_date > NOW(), true, false) AS is_current_employee 
FROM dept_emp AS de
	JOIN employees AS e
		USING (emp_no);		

/*-- insert CASE: 331603 rows is more than actual hired employees b'c employees changed depts and created duplicates
SELECT 
	emp_no, 
	dept_no, 
	hire_date, 
	to_date,
	IF(to_date > NOW(), true, false) AS is_current_employee 
FROM dept_emp AS de
	JOIN (
		SELECT 
			emp_no, 
			MAX(to_date) AS max_date
		FROM dept_emp
		GROUP BY emp_no	
			)
	FROM dept_emp
	GROUP BY emp_no AS last_dept
	USING (emp_no)
		WHERE de.to_date = last_dept.to_date
	JOIN employees AS e 
		USING (emp_no);
*/

-- returns correct # of historical employees
SELECT 
	emp_no, 
	MAX(to_date) AS max_date
FROM dept_emp
GROUP BY emp_no;




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
				
		WHEN last_name > 'Q'
				THEN 'R-Z'
				
		ELSE last_name
		END AS alpha_group
		
FROM employees
ORDER BY last_name, first_name;


-- 3. How many employees (current or previous) were born in each decade?

/*
182886	atomic_boomer
117138	flower_child
*/

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

/*
use easley_1261;

-- create temporary table tempdecade AS (
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
FROM employees.employees
ORDER BY birth_date, last_name, first_name
											);

select *
from tempdecade;
*/



-- count decades
SELECT count(birth_date)
FROM employees
WHERE birth_date LIKE '195%'
;

-- count decades
SELECT count(birth_date)
FROM employees
WHERE birth_date LIKE '196%'
;


/*
-- attempt at counting with case subquery
SELECT COUNT(*)
FROM employees
WHERE birth_date IN (
		SELECT 
			CASE 
				WHEN birth_date LIKE '195%'
					THEN Atomic_Boomer
				WHEN birth_date LIKE '196%'
					THEN Flower_Child
				ELSE birth_date
				END AS birth_decade
		FROM employees
						)
GROUP BY birth_date;
*/


-- use of case dto produce final counts
SELECT 
	COUNT(emp_no),
	CASE 
		WHEN birth_date LIKE '195%'
			THEN 'atomic_boomer'
		WHEN birth_date LIKE '196%'
			THEN 'flower_child'
		ELSE birth_date
		END AS birth_decade
FROM employees
GROUP BY birth_decade;



/*
-- convert to temp table
use easley_1261;

CREATE TEMPORARY TABLE emp_decade AS (
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
						FROM employees.employees
											);
*/





/*BONUS

What is the current average salary for each of the following department groups: 
R&D, 
Sales & Marketing, 
Prod & QM, 
Finance & HR, 
Customer Service?
*/

use employees;

-- use a case to create a table with a column grouping as requested
SELECT emp_no, salary, dept_name,
	CASE
		WHEN dept_name IN ('Research', 'Development')
			THEN 'R&D'
		WHEN dept_name IN ('sales', 'marketing') 
			THEN 'Sales & Marketing' 
		WHEN dept_name IN ('Production', 'Quality Management') 
			THEN 'Prod & QM'
		WHEN dept_name IN ('Finance', 'Human Resources') 
			THEN 'Finance & HR' 
            ELSE 'Customer Service'
            END AS dept_group
FROM employees.salaries
	JOIN employees_with_departments
		USING(emp_no);
#GROUP BY dept_group;

-- filter the to get current salaries
SELECT ROUND(avg(salary), 2),
	CASE
		WHEN dept_name IN ('Research', 'Development')
			THEN 'R&D'
		WHEN dept_name IN ('sales', 'marketing') 
			THEN 'Sales & Marketing' 
		WHEN dept_name IN ('Production', 'Quality Management') 
			THEN 'Prod & QM'
		WHEN dept_name IN ('Finance', 'Human Resources') 
			THEN 'Finance & HR' 
            ELSE 'Customer Service'
            END AS dept_group
FROM employees.salaries
	JOIN employees_with_departments
		USING(emp_no)
WHERE employees.salaries.to_date > NOW()
GROUP BY dept_group;


-- clean up table
SELECT CONCAT('$', ' ', ROUND(avg(salary), 2)) AS current_avg_salary,
	CASE
		WHEN dept_name IN ('Research', 'Development')
			THEN 'R&D'
		WHEN dept_name IN ('sales', 'marketing') 
			THEN 'Sales & Marketing' 
		WHEN dept_name IN ('Production', 'Quality Management') 
			THEN 'Prod & QM'
		WHEN dept_name IN ('Finance', 'Human Resources') 
			THEN 'Finance & HR' 
            ELSE 'Customer Service'
            END AS dept_group
FROM employees.salaries
	JOIN employees_with_departments
		USING(emp_no)
WHERE employees.salaries.to_date > NOW()
GROUP BY dept_group;

-- rearrange table to look like example
SELECT 
	CASE
		WHEN dept_name IN ('Research', 'Development')
			THEN 'R&D'
		WHEN dept_name IN ('sales', 'marketing') 
			THEN 'Sales & Marketing' 
		WHEN dept_name IN ('Production', 'Quality Management') 
			THEN 'Prod & QM'
		WHEN dept_name IN ('Finance', 'Human Resources') 
			THEN 'Finance & HR' 
            ELSE 'Customer Service'
            END AS dept_group,
	CONCAT('$', ' ', ROUND(avg(salary), 2)) AS current_avg_salary
FROM employees.salaries
	JOIN employees_with_departments
		USING(emp_no)
WHERE employees.salaries.to_date > NOW()
GROUP BY dept_group;


