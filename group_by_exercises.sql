use employees;

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
SELECT concat(
					substr(LOWER(first_name),1,1), 
					substr(LOWER(last_name),1,4), 
					"_", 
					substr(birth_date,6,2), 
					substr(birth_date,3,2)
					) 
			AS username,count(*)
FROM employees
GROUP BY username
ORDER BY count(*) DESC;


# Yes, there are duplicates: 13251. 

SELECT COUNT(DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees;

SELECT COUNT(DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees
WHERE count(*) > 1;

SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		count(*) AS 'Number'
FROM employees
#WHERE count(*) IN (6, 5, 4, 3, 2) 
GROUP BY username
ORDER BY Number DESC;

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
#WHERE username = username
GROUP BY username
ORDER BY count(*) DESC
LIMIT 25 OFFSET 13250;

SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		count(*)
FROM employees
#WHERE username = username
GROUP BY username
ORDER BY count(*) DESC
LIMIT 25 OFFSET 13250;

SELECT  concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username,
		count(*)
FROM employees
GROUP BY username
HAVING COUNT(username) > 1;

SELECT  COUNT(DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees
HAVING (count(*) > 1);

SELECT COUNT(concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) AS username)
FROM employees
HAVING COUNT(username) > 1;
#WHERE count(*) IN (6, 5, 4, 3, 2) 
#GROUP BY username
#ORDER BY Number DESC;

SELECT COUNT(DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)))
FROM employees;

SELECT COUNT(*) AS usernames
FROM (SELECT DISTINCT concat(substr(LOWER(first_name),1,1), 
		substr(LOWER(last_name),1,4), 
		"_", 
		substr(birth_date,6,2), 
		substr(birth_date,3,2)) FROM employees)
WHERE usernames in (6, 5, 4, 3, 2);

SELECT COUNT(DISTINCT concat(
										substr(LOWER(first_name),1,1), 
										substr(LOWER(last_name),1,4), 
										"_", 
										substr(birth_date,6,2), 
										substr(birth_date,3,2)
										)
					) AS username, count(*)
FROM employees
HAVING COUNT(username) != 1;


SELECT COUNT(logins.numbers) AS 'Number of Duplicate Usernames'
FROM(

		SELECT concat(
							substr(LOWER(first_name),1,1), 
							substr(LOWER(last_name),1,4), 
							"_", 
							substr(birth_date,6,2), 
							substr(birth_date,3,2)
						  ) 
					AS username, count(*) AS numbers
		FROM employees
		GROUP BY username
		
    ) AS logins
WHERE logins.numbers != 1;



