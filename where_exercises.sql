use employees;


#2
select * 
from employees
WHERE first_name in ('Irena', 'Vidya', 'Maya');
#709 records returned

#3
select * 
from employees
WHERE first_name = 'Irena'
	or first_name = 'Vidya'
	or first_name =  'Maya';
#709 records returned, same as Q2.
	
#4
select * 
from employees
WHERE 
	(first_name = 'Irena'
	or first_name = 'Vidya'
	or first_name =  'Maya')
and 
	gender = 'M';
#441 records returned

#5
select *
from employees
WHERE
	last_name LIKE 'E%';
# 7330 employees whose last name starts with E.

#6
select *
from employees
WHERE
	last_name LIKE 'E%'
	or last_name LIKE '%e';
#30723 employees whose last name starts or ends with E. 

select *
from employees
WHERE
	last_name LIKE '%e'
	AND NOT last_name like 'E%';
#23393 employees have a last name that ends with E, but does not start with E.


#7
select *
from employees
WHERE
	last_name LIKE 'E%'
	AND last_name LIKE '%e';
# 899 employees whose last name starts and ends with 'E'. 

select *
from employees
WHERE
	last_name LIKE '%e';
# 24292 employees' last names end with E, regardless of whether they start with E.

#8 
select *
from employees
WHERE hire_date LIKE '199%';
# 135214 employees hired in the 90s

#9
select *
from employees
WHERE birth_date LIKE '%-12-25';
# 842 employees born on Christmas.

#10
select *
from employees
WHERE 
	birth_date LIKE '%-12-25'
	AND
	hire_date LIKE '199%';
# 362 employees hired in the 90s and born on Christmas.

#11 
select *
from employees
WHERE last_name LIKE '%q%';
# 1873 employees with a 'q' in their last name.

#12
select *
from employees
WHERE 
	last_name LIKE '%q%'
	AND NOT last_name LIKE'%qu%';
# 547 employees with a 'q' in their last name but not 'qu'.
