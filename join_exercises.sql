/*JOIN EXAMPLE DATABASE*/

-- #1
SELECT *
FROM roles;

SELECT *
FROM users;

SELECT *
FROM users
JOIN roles ON users.role_id = roles.id;

-- #2
-- Join Ex: excludes NULLs
SELECT *
FROM users
JOIN roles ON users.role_id = roles.id;

-- LEFT Join Ex: includes NULLs on id's 5 & 6, under role_id and name
SELECT *
FROM users
LEFT JOIN roles ON users.role_id = roles.id;

-- RIGHT Join Ex: includes NULLs for commenter's id/name/email/role_id since there are no commenters 
SELECT *
FROM users
RIGHT JOIN roles ON users.role_id = roles.id;

-- #3 lists all possible ROLES and the number of USERS that have that role.
SELECT roles.name, count(users.name)
FROM users
RIGHT JOIN roles ON users.role_id = roles.id
GROUP BY roles.name;




/*EMPLOYEES DATABASE*/

-- 1
USE employees;

-- 2: shows each department along with the name of the current manager for that department.
/*
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de
  ON de.emp_no = e.emp_no
JOIN departments AS d
  ON d.dept_no = de.dept_no;
#WHERE de.to_date = '9999-01-01' AND e.emp_no = 10001;*/


SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager'
FROM employees AS e
	JOIN dept_manager AS dm
		ON dm.emp_no = e.emp_no
	JOIN departments AS d
		on d.dept_no = dm.dept_no
		
WHERE dm.to_date > curdate()
ORDER BY d.dept_name;

-- 3: lists the name of all departments currently managed by women.
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager'
FROM employees AS e
	JOIN dept_manager AS dm
		ON dm.emp_no = e.emp_no
	JOIN departments AS d
		on d.dept_no = dm.dept_no
	
WHERE dm.to_date > curdate()
AND e.gender = 'F'
ORDER BY d.dept_name;

-- 4: Find the current titles of employees currently working in the Customer Service department.
SELECT t.title AS 'Title', count(de.emp_no) AS 'Count'
FROM titles AS t
	JOIN dept_emp as de
		ON de.emp_no = t.emp_no
	WHERE de.to_date > curdate()
	AND t.to_date > curdate()
	AND de.dept_no = 'd009'
GROUP BY t.title;

-- 5: Find the current salary of all current managers.
SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager', s.salary AS 'Salary'
FROM employees AS e
	JOIN dept_manager AS dm
		ON dm.emp_no = e.emp_no
	JOIN departments AS d
		on d.dept_no = dm.dept_no
	JOIN salaries AS s
		ON s.emp_no = dm.emp_no
		
WHERE dm.to_date > curdate()
AND s.to_date > curdate()
ORDER BY d.dept_name;

-- 6: Find the number of current employees in each department.
SELECT d.dept_no, d.dept_name, COUNT(emp_no) AS num_employees
FROM dept_emp AS de
	JOIN departments AS d
		ON de.dept_no = d.dept_no
WHERE de.to_date > curdate()
GROUP BY d.dept_no
ORDER BY d.dept_no;

-- 7: Which department has the highest average salary? Hint: Use current not historic information.
/*
SELECT dept_no, avg(salary)
from salaries
join dept_emp using (emp_no)
group by dept_no
order by avg(salary) desc;
*/

SELECT d.dept_name, ROUND(avg(s.salary), 2) AS 'average_salary'
FROM departments AS d
	JOIN dept_emp AS de
		ON d.dept_no = de.dept_no
	JOIN salaries AS s
		ON s.emp_no = de.emp_no
WHERE s.to_date > curdate()
AND de.to_date > curdate()
GROUP BY d.dept_name
ORDER BY average_salary DESC
LIMIT 1;

-- 8: Who is the highest paid employee in the Marketing department?
SELECT e.first_name, e.last_name
FROM salaries AS s
	JOIN employees AS e
		ON s.emp_no = e.emp_no
	JOIN dept_emp AS de
		ON s.emp_no = de.emp_no
WHERE s.to_date > curdate()
AND de.dept_no = 'd001'
ORDER BY s.salary DESC
LIMIT 1;
		
-- 9:Which current department manager has the highest salary?
SELECT e.first_name, e.last_name, s.salary, d.dept_name
FROM employees AS e
	JOIN dept_manager AS dm
		ON dm.emp_no = e.emp_no
	JOIN departments AS d
		ON d.dept_no = dm.dept_no
	JOIN salaries AS s
		ON s.emp_no = dm.emp_no
	
WHERE dm.to_date > curdate()
AND s.to_date > curdate()
ORDER BY s.salary DESC
LIMIT 1;




-- 10:Bonus Find the names of all current employees, their department name, and their current manager's name.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', 
		ewd.dept_name AS 'Department Name', 
		CONCAT(ewd.first_name, ' ', ewd.last_name) AS 'Manager Name'
		
FROM dept_emp AS de
	JOIN dept_manager AS dm
		ON de.dept_no = dm.dept_no
	JOIN employees_with_departments AS ewd
		ON dm.emp_no = ewd.emp_no
	JOIN employees AS e
		ON e.emp_no = de.emp_no

WHERE de.to_date = '9999-01-01'
AND dm.to_date = '9999-01-01'
ORDER BY ewd.dept_name, e.last_name, e.first_name;  

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', 
		ewd.dept_name AS 'Department Name', 
		CONCAT(ewd.first_name, ' ', ewd.last_name) AS 'Manager Name'
		
FROM dept_emp AS de
	JOIN dept_manager AS dm
		ON de.dept_no = dm.dept_no
	JOIN employees_with_departments AS ewd
		ON dm.emp_no = ewd.emp_no
	JOIN employees AS e
		ON e.emp_no = de.emp_no

WHERE de.to_date > CURDATE()
AND dm.to_date > CURDATE()
ORDER BY ewd.dept_name, e.last_name, e.first_name;  

/*
SELECT *	
FROM employees AS e
	JOIN dept_emp AS de
		ON de.emp_no = e.emp_no
	JOIN dept_manager AS dm
		ON dm.dept_no = de.dept_no
	JOIN employees_with_departments AS ewd
		ON ewd.emp_no = dm.emp_no; 
*/


-- Faith's stab at #10
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name',
	d.dept_name AS 'Department Name',
	m.managers AS 'Manager Name'
FROM employees AS e
JOIN dept_emp AS de ON de.emp_no = e.emp_no
	AND de.to_date > CURDATE()
JOIN departments AS d ON de.dept_no = d.dept_no 
JOIN (SELECT
		 	dm.dept_no,
		 	CONCAT(e.first_name, ' ', e.last_name) AS managers
	 	FROM employees AS e
	 	JOIN dept_manager AS dm 
	 		ON e.emp_no = dm.emp_no
		AND to_date > CURDATE()
	  ) AS m 
	  	  ON m.dept_no = d.dept_no
ORDER BY d.dept_name;  

-- Ryan's take on #10
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS 'employee_name', 
		dept_name, 
		dept_manager.emp_no,
		CONCAT(managers.first_name, ' ', managers.last_name) AS 'manager_name'
FROM employees
JOIN dept_emp USING(emp_no)
JOIN departments USING(dept_no)
JOIN dept_manager USING(dept_no)
JOIN employees AS managers
	ON managers.emp_no = dept_manager.emp_no
WHERE dept_manager.to_date > curdate()
AND dept_emp.to_date > curdate();

-- 11: Bonus Who is the highest paid employee within each department.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', ewd.dept_name AS 'Department Name', s.salary
		
FROM dept_emp AS de
	JOIN dept_manager AS dm
		ON de.dept_no = dm.dept_no
	JOIN employees_with_departments AS ewd
		ON dm.emp_no = ewd.emp_no
	JOIN employees AS e
		ON e.emp_no = de.emp_no
	JOIN salaries AS s 
		ON s.emp_no  = e.emp_no

WHERE de.to_date = '9999-01-01'
AND dm.to_date = '9999-01-01'
AND s.to_date > NOW();
#AND e.emp_no NOT IN (111939, 110567, 110114, 110228, 110039, 110420, 110854, 111534, 111133)

#ORDER BY ewd.dept_name, s.salary DESC;

-- -- DAY TWO ATTEMPTS -- -- 

-- gather all necessary tables
SELECT *
FROM employees AS e
	JOIN salaries AS s
		ON s.emp_no = e.emp_no
			AND s.to_date > NOW()
	JOIN dept_emp AS de
		ON de.emp_no = e.emp_no
			AND de.to_date > NOW()
	JOIN departments AS d
		ON d.dept_no = de.dept_no;

-- create a list of all max(salaries) separated by dept_name
SELECT max(salary)
FROM employees AS e
	JOIN salaries AS s
		ON s.emp_no = e.emp_no
			AND s.to_date > NOW()
	JOIN dept_emp AS de
		ON de.emp_no = e.emp_no
			AND de.to_date > NOW()
	JOIN departments AS d
		ON d.dept_no = de.dept_no
GROUP BY dept_name;

-- combine
SELECT *
FROM employees AS e
	JOIN salaries AS s
		ON s.emp_no = e.emp_no
			AND s.to_date > NOW()
	JOIN dept_emp AS de
		ON de.emp_no = e.emp_no
			AND de.to_date > NOW()
	JOIN departments AS d
		ON d.dept_no = de.dept_no
WHERE salary IN (
				SELECT max(salary)
				FROM employees AS e
					JOIN salaries AS s
						ON s.emp_no = e.emp_no
							AND s.to_date > NOW()
					JOIN dept_emp AS de
						ON de.emp_no = e.emp_no
							AND de.to_date > NOW()
					JOIN departments AS d
						ON d.dept_no = de.dept_no
				GROUP BY dept_name				
						);
						
-- clean up columns AND ORDER
SELECT e.emp_no, first_name, last_name, dept_name, salary
FROM employees AS e
	JOIN salaries AS s
		ON s.emp_no = e.emp_no
			AND s.to_date > NOW()
	JOIN dept_emp AS de
		ON de.emp_no = e.emp_no
			AND de.to_date > NOW()
	JOIN departments AS d
		ON d.dept_no = de.dept_no
WHERE salary IN (
				SELECT max(salary)
				FROM employees AS e
					JOIN salaries AS s
						ON s.emp_no = e.emp_no
							AND s.to_date > NOW()
					JOIN dept_emp AS de
						ON de.emp_no = e.emp_no
							AND de.to_date > NOW()
					JOIN departments AS d
						ON d.dept_no = de.dept_no
				GROUP BY dept_name				
						)
ORDER BY salary DESC;

						




SELECT 
		CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name', 
		ewd.dept_name AS 'Department Name', 
		s.salary
		
FROM dept_emp AS de
	JOIN employees_with_departments AS ewd
		ON de.dept_no = ewd.dept_no
		AND to_date > NOW()
	JOIN employees AS e
		ON e.emp_no = de.emp_no
	JOIN salaries AS s 
		ON s.emp_no  = e.emp_no
		AND to_date > NOW()


#AND e.emp_no NOT IN (111939, 110567, 110114, 110228, 110039, 110420, 110854, 111534, 111133)
GROUP BY ewd.dept_name
ORDER BY ewd.dept_name, s.salary DESC;






-- Faith's take on #11
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name',
    d.dept_name AS 'Department Name',
    CONCAT(managers.first_name, ' ', managers.last_name) AS 'Manager_name'
FROM dept_emp AS de
JOIN employees AS e USING(emp_no)
JOIN departments AS d ON d.dept_no = de.dept_no
-- Get the current department managers, join on dept_no.
JOIN dept_manager AS dm ON dm.dept_no = d.dept_no 
    AND dm.to_date > CURDATE()
-- Join employees again as managers to get manager names.
JOIN employees AS managers ON managers.emp_no = dm.emp_no
WHERE de.to_date > CURDATE()
ORDER BY d.dept_name;



-- Ryan's input on #11
SELECT max(salary)
FROM employees AS e
JOIN salaries AS s
	ON s.emp_no = e.emp_no
JOIN dept_emp AS de
	on de.emp_no = de.emp_no
JOIN departments AS d
	on d.dept_no = de.dept_no
GROUP BY dept_name;

