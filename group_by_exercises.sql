use employees;

select dept_n, count(*)
from dept_emp
GROUP BY dept_no;

select distinct dept_no
from dept_emp;

select dept_no, count(*)
from dept_emp
group by dept_no;

select dept_no, count(*)
from dept_emp
where to_date > curdate()
group by dept_no;

select hire_date, count(*)
from employees
where first_name = 'Georgi'
group by hire_date
order by count(*) DESC;







-- 2
select DISTINCT title
from titles;
#7 Unique titles

-- 3
select last_name
from employees
WHERE
	last_name LIKE 'E%e'
GROUP BY last_name;

-- 4
select DISTINCT CONCAT(first_name, " ", last_name) AS 'Full Name'
from employees
WHERE
	last_name LIKE 'E%e';

-- 5
select DISTINCT last_name
from employees
WHERE 
	last_name LIKE '%q%'
	AND NOT last_name LIKE'%qu%';

-- 6 
select last_name, count(*)
from employees
WHERE 
	last_name LIKE '%q%'
	AND NOT last_name LIKE'%qu%'
GROUP BY last_name;

-- 7 
select first_name, gender, count(*) 
from employees
WHERE first_name in ('Irena', 'Vidya', 'Maya')
GROUP BY first_name, gender
ORDER BY gender DESC, first_name;

select concat (first_name, "  ", gender) AS 'Name and Gender', count(*) 
from employees
WHERE first_name in ('Irena', 'Vidya', 'Maya')
GROUP BY first_name, gender
ORDER BY gender DESC, first_name;

-- 8 
SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		count(*)
FROM employees
GROUP BY username
ORDER BY count(*) DESC;


# Yes, there are duplicates. 

SELECT  COUNT(DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees;

SELECT  COUNT(IS [NOT] DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees;

SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		count(*)
FROM employees
WHERE username = username
GROUP BY username
ORDER BY count(*) DESC;
