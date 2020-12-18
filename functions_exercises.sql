SHOW tables;

USE employees;
          
DESCRIBE titles;

-- 2
select concat(first_name, " ", last_name) AS full_name
from employees
WHERE
	last_name LIKE 'E%e';
	
-- 3
select UPPER(concat(first_name, " ", last_name)) AS full_name
from employees
WHERE
	last_name LIKE 'E%e';

-- 4
select concat(first_name, " ", last_name) AS 'Full Name',
	   DATEDIFF(NOW(),hire_date) AS 'Days With Company'
FROM employees
WHERE hire_date LIKE '199%'
	AND
	  birth_date LIKE '%-12-25'
ORDER BY hire_date;

-- 5
#Smallest Salary
SELECT MIN(salary) AS 'Smallest Salary'
FROM salaries;

#Largest Salary
SELECT MAX(salary) AS 'Largest Salary'
FROM salaries;

-- 6
SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		first_name, last_name, birth_date
FROM employees;

