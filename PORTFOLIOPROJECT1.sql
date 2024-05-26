ALTER TABLE `employee sample data` RENAME employee_data;

SELECT *
FROM employee_data;

-- looking at the employee with the highest age

SELECT `full name`, age
FROM employee_data
ORDER BY age DESC;

-- looking at department with highest salary in all departments

SELECT department, `annual salary`
FROM employee_data
ORDER BY department, `annual salary` DESC;


-- looking at job title and salary

SELECT `job title`, `annual salary` salary
FROM employee_data
ORDER BY `job title`, salary DESC
;

-- looking at names, age and gender 

SELECT gender, age
FROM employee_data
GROUP BY gender, age
ORDER BY gender, age DESC
;

SELECT AVG(age) avg_age
FROM employee_data;

SELECT  gender, AVG(age) avg_age
FROM employee_data
WHERE gender LIKE 'female'
GROUP BY gender
;

SELECT  gender, AVG(age) avg_age
FROM employee_data
WHERE gender LIKE 'male'
GROUP BY gender
;

SELECT department, country, city
FROM employee_data
ORDER BY country DESC
;

SELECT `exit date`, department, country
FROM employee_data
ORDER BY country DESC, 2,3
;

SELECT `full name`, `business unit` business_unit, `bonus %` bonusper
FROM employee_data
ORDER BY bonusper, 2
;

SELECT gender, `bonus %` bonusper
FROM employee_data
ORDER BY bonusper DESC, 1,2
;


SELECT `full name`, `hire date` hire_date, `exit date` exit_date
FROM employee_data
;



CREATE VIEW EmployeeDemographics AS
SELECT `business unit`, 
`annual salary`,
`bonus %`,
country,
city,
`exit date`,
`hire date`
FROM employee_data;

