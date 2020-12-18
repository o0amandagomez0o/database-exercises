SHOW tables;

USE employees;

#2
SELECT DISTINCT last_name
FROM employees
ORDER BY last_name DESC
LIMIT 10;
/*
Zykh
Zyda
Zwicker
Zweizig
Zumaque
Zultner
Zucker
Zuberek
Zschoche
Zongker
*/

#3 
select *
FROM employees
WHERE hire_date LIKE '199%'
	AND
	  birth_date LIKE '%-12-25'
ORDER BY hire_date 
LIMIT 5;
# Alselm Cappello
# Utz Mandell
# Bouchung Schreiter
# Baocai Kushner
# Petter Stroustrup

#4
select concat(first_name," ", last_name) AS 'Full Name'
FROM employees
WHERE hire_date LIKE '199%'
	AND
	  birth_date LIKE '%-12-25'
ORDER BY hire_date 
LIMIT 5 OFFSET 45;
/*
Pranay Narwekar
Marjo Farrow
Ennio Karcich
Dines Lubachevsky
Ipke Fontan
*/
# The relationship between LIMIT & OFFSET can be viewed as a function: OFFSET = LIMIT*p-LIMIT.

select *
FROM employees
WHERE hire_date LIKE '199%'
	AND
	  birth_date LIKE '%-12-25'
ORDER BY hire_date 
LIMIT 50;


