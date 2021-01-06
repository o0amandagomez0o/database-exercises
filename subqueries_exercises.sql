-- Create a file named subqueries_exercises.sql and craft queries to return the results for the following criteria

-- 1. Find all the current employees with the same hire date as employee 101010 using a sub-query.

-- confirm same hire_date 
SELECT *
FROM employees AS e
JOIN dept_emp AS de
	ON de.emp_no = e.emp_no
WHERE hire_date IN (
				SELECT hire_date
				FROM employees
				WHERE emp_no = 101010
						);

-- narrow down columns 
SELECT hire_date, CONCAT(first_name, ' ', last_name) 
FROM employees AS e
JOIN dept_emp AS de
	ON de.emp_no = e.emp_no
WHERE hire_date IN (
				SELECT hire_date
				FROM employees
				WHERE emp_no = 101010
						)
AND de.to_date > NOW();

-- final clean up label and order by
SELECT CONCAT(first_name, ' ', last_name) AS 'Employees with same hire date as emp101010'
FROM employees AS e
JOIN dept_emp AS de
	ON de.emp_no = e.emp_no
WHERE hire_date IN (
				SELECT hire_date
				FROM employees
				WHERE emp_no = 101010
						)
AND de.to_date > NOW()
ORDER BY last_name, first_name;


-- 2. Find all the titles ever held by all current employees with the first name Aamod.

-- start with first name
SELECT *
FROM employees as e
WHERE first_name = 'Aamod';
						
-- join dept_emp to filter current emps
SELECT *
FROM employees as e
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
WHERE first_name = 'Aamod'
AND de.to_date > NOW();
						
-- join titles to get title info
SELECT *
FROM employees as e
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
JOIN titles AS t
	ON t.emp_no = e.emp_no
WHERE first_name = 'Aamod'
AND de.to_date > NOW();


-- adj the select columns
SELECT first_name, title
FROM employees as e
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
JOIN titles AS t
	ON t.emp_no = e.emp_no
WHERE first_name = 'Aamod'
AND de.to_date > NOW();

-- clean up with grouping
SELECT first_name, title
FROM employees as e
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
JOIN titles AS t
	ON t.emp_no = e.emp_no
WHERE first_name = 'Aamod'
AND de.to_date > NOW()
GROUP BY title;

-- 3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
/*59900*/
SELECT *
FROM employees AS e

WHERE e.emp_no NOT IN(
						SELECT de.emp_no
						FROM dept_emp AS de
						WHERE de.to_date > NOW()
						);

-- find all former emps ALTHOUGH this does not incl Managers
SELECT *
FROM dept_emp AS de
WHERE de.to_date < NOW();

-- start from employes DB and filter out current emps
SELECT *
FROM employees AS e

WHERE e.emp_no NOT IN(
						SELECT de.emp_no
						FROM dept_emp AS de
						WHERE de.to_date > NOW()
						);

-- create subquiry that addresses former employees
SELECT *
FROM dept_emp AS de
JOIN dept_manager AS dm
	ON dm.dept_no = de.dept_no
WHERE de.to_date < NOW()
AND dm.to_date < NOW()
						;										
--
SELECT *
FROM employees AS e

WHERE e.emp_no IN(
						SELECT *
						FROM dept_emp AS de
						JOIN dept_manager AS dm
							ON dm.dept_no = de.dept_no
						WHERE de.to_date < NOW()
						AND dm.to_date < NOW()
						);

-- create a list of currently paid emps
SELECT emp_no
FROM salaries AS s
GROUP BY emp_no;

-- Create employees framework
SELECT *
FROM employees AS e
WHERE emp_no NOT IN (
							
							);

-- Add current emps as subquiry, incl WHERE to filter current emps
SELECT *
FROM employees AS e
WHERE e.emp_no NOT IN (
							SELECT s.emp_no
							FROM salaries AS s
							WHERE s.to_date > NOW()
							GROUP BY s.emp_no
							);
-- count 'em!
SELECT COUNT(*)
FROM employees AS e
WHERE e.emp_no NOT IN (
							SELECT s.emp_no
							FROM salaries AS s
							WHERE s.to_date > NOW()
							GROUP BY s.emp_no
							);


-- 4. Find all the current department managers that are female. List their names in a comment in your code.
/*
Isamu Legleitner
Karsten Sigstam
Leon DasSarma
Hilary Kambil
*/
-- filter only females from employees table
SELECT first_name, last_name
FROM employees AS e
WHERE gender = 'F';

-- create list of current managers
SELECT *
FROM dept_manager
WHERE to_date > NOW();

-- Place current mngrs subquery into Female query
SELECT first_name, last_name
FROM employees AS e
WHERE emp_no IN (
			SELECT emp_no
			FROM dept_manager
			WHERE to_date > NOW()
						)
AND gender = 'F';


-- Clean up title
SELECT CONCAT(first_name, ' ', last_name)
FROM employees AS e
WHERE emp_no IN (
			SELECT emp_no
			FROM dept_manager
			WHERE to_date > NOW()
						)
AND gender = 'F';

-- 5. Find all the employees who currently have a higher salary than the companies overall, historical average salary.

-- find overall avg(salary)
SELECT ROUND(avg(salary),2)
FROM salaries;

-- FIND current employees
SELECT *
FROM employees AS e
JOIN salaries AS s
	ON s.emp_no = e.emp_no
WHERE s.to_date > NOW();

-- get just names
SELECT CONCAT(first_name, ' ', last_name) AS 'Employee Name'
FROM employees AS e
JOIN salaries AS s
	ON s.emp_no = e.emp_no
WHERE s.to_date > NOW();

-- put in subquery
SELECT CONCAT(first_name, ' ', last_name) AS 'Employee Name'
FROM employees AS e
JOIN salaries AS s
	ON s.emp_no = e.emp_no
WHERE s.salary > (
				SELECT ROUND(avg(salary),2)
				FROM salaries
						)
AND s.to_date > NOW();

-- clean up
SELECT CONCAT(first_name, ' ', last_name) AS 'Employee Name', s.salary AS 'Current Salary'
FROM employees AS e
JOIN salaries AS s
	ON s.emp_no = e.emp_no
WHERE s.salary > (
				SELECT ROUND(avg(salary),2)
				FROM salaries
						)
AND s.to_date > NOW()
ORDER BY s.salary;

-- 6. How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?

/*83 current employees' salaries are within 1 std dev from the max(salary) 
(83/240124)*(100) = .0346% */

-- find the max(salary)
SELECT max(s.salary)
FROM salaries AS s;

-- find the current max(salary)
SELECT max(s.salary)
FROM salaries AS s
WHERE s.to_date > NOW();

-- find all current salaries
SELECT *
FROM salaries AS s
WHERE s.to_date > NOW();

-- count
SELECT COUNT(*)
FROM salaries AS s
WHERE s.to_date > NOW();

-- stddev of salarY
SELECT ROUND(stddev(s.salary), 2)
FROM salaries AS s
WHERE s.to_date > NOW();

-- find the emps within one std dev away from the max salary: put them all together
SELECT *
FROM salaries AS s
WHERE s.salary > (
				(SELECT max(s.salary)
				FROM salaries AS s
				WHERE s.to_date > NOW())
				-
				(SELECT ROUND(stddev(s.salary), 2)
				FROM salaries AS s
				WHERE s.to_date > NOW())
						) 
AND s.to_date > NOW();

-- count
SELECT COUNT(*)
FROM salaries AS s
WHERE s.salary > (
				(SELECT max(s.salary)
				FROM salaries AS s
				WHERE s.to_date > NOW())
				-
				(SELECT ROUND(stddev(s.salary), 2)
				FROM salaries AS s
				WHERE s.to_date > NOW())
						) 
AND s.to_date > NOW();

-- calculate percentage
(()/())*(100);

SELECT
(
	(SELECT COUNT(*)
	FROM salaries AS s
	WHERE s.salary > (
				(SELECT max(s.salary)
				FROM salaries AS s
				WHERE s.to_date > NOW())
				-
				(SELECT ROUND(stddev(s.salary), 2)
				FROM salaries AS s
				WHERE s.to_date > NOW())
						) 
	AND s.to_date > NOW())
/
	(SELECT COUNT(*)
	FROM salaries AS s
	WHERE s.to_date > NOW())
)*(100);


-- -- liam's code dissected
select
 (Select count(salary)
 from salaries
 where salary > (
        Select 
        max(salary) - STDDEV(salary)
        from salaries
        Where to_date > curdate())
 AND to_date > curdate())
 /
 (select
 count(salary)
 from salaries
 Where to_date > curdate())
 *100;

Select *
 from salaries
 where salary > (
        Select 
        max(salary) - STDDEV(salary)
        from salaries
        Where to_date > curdate())
 AND to_date > curdate()
 ORDER BY emp_no;


select
 count(salary)
 from salaries
 Where to_date > curdate();

/*BONUS*/

-- 1. Find all the department names that currently have female managers.

-- 2. Find the first and last name of the employee with the highest salary.

-- 3. Find the department name that the employee with the highest salary works in.