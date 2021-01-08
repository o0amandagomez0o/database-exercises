/*Employees Database
How much do the current managers of each department get paid, 
relative to the average salary for the department? 
Is there any department where the department manager gets paid 
less than the average salary?*/

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



































