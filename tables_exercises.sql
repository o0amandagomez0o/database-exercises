# Notes
# What different data types are present on this table? Numeric, string, & date.
# Which table(s) do you think contain a numeric type column? employees, current_dept_emp, dept_emp, dept_emp_latest_date, dept_manager, employees_with_departments, salaries, titles.
# Which table(s) do you think contain a string type column? employees, current_dept_emp, departments, dept_emp, dept_manager, employees_with_departments, titles.
# Which table(s) do you think contain a date type column? employees, current_dept_emp, dept_emp, dept_emp_latest_date, dept_manager, salaries, titles.
# What is the relationship between the employees and the departments tables?
# Show the SQL that created the dept_manager table. SHOW CREATE TABLE dept_manager;

# SQL code

use employees;
show TABLES;
DESCRIBE employees;
DESCRIBE current_dept_emp;
DESCRIBE departments;
DESCRIBE dept_emp;
DESCRIBE dept_emp_latest_date;
DESCRIBE dept_manager;
DESCRIBE employees_with_departments;
DESCRIBE salaries;
DESCRIBE titles;

SHOW CREATE TABLE dept_manager;