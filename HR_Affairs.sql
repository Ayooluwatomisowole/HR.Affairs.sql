
-- Data Cleaning 
-- Typographical error correction 

SELECT *
  FROM [dbo].[Termination_info]
  WHERE Reason = 'Reallocation out of the area'

  UPDATE [dbo].[Termination_info]
  SET Reason = 'Relocation out of the area'
  WHERE Reason = 'Reallocation Out Of The Area'

  
-- Data Exploration 
-- Average salary by job department 

SELECT Department, ROUND(AVG(MonthlySalary),1) Avg_salary
FROM Employeesalary
GROUP BY Department

-- Employees with the highest sal in each department 

WITH ranked_salaries AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY MonthlySalary DESC) AS salary_rank
    FROM EmployeeSalary
)
SELECT * 
FROM ranked_salaries
WHERE salary_rank = 1

-- How many employees were terminated from each deapartment
-- Using JOIN to combine both tables to extract department name and termination count 

SELECT ed.Department, COUNT(ti.EmployeeID) terminated_count
FROM [HR Employee data] ed 
JOIN Termination_info ti
    ON ed.EmployeeID = ti.EmployeeID
GROUP BY Department


-- Which office has the highest average employee satisfaction score from the office survey?
-- Six of the offices have the same average of 9 while the other 2 have 6

SELECT Off_cde, ROUND(AVG(rating),0) AS average_satisfaction_score
FROM employee_office_survey
GROUP BY off_cde
ORDER BY average_satisfaction_score DESC

-- What is the distribution of employees by gender?

SELECT Gender, COUNT(*) employee_count
FROM [HR Employee data]
GROUP BY Gender

-- Top 5 highest earners in the company 

SELECT TOP(5) EmployeeID, Department, MAX(MonthlySalary) sal_rank
FROM EmployeeSalary
GROUP BY EmployeeID, Department
ORDER BY sal_rank DESC

-- Which employee has the longest tenure in the company?

SELECT TOP(1) EmployeeID, MIN(JoiningYear) emp_tenure
FROM [HR Employee data]
GROUP BY EmployeeID
ORDER BY emp_tenure

--Employee turnover rate by gender?
--Using temp table 

WITH EmployeeTurnover AS (
    SELECT
        ed.gender,
        COUNT(ti.EmployeeID) AS turnover_count,
        COUNT(ed.EmployeeID) AS total_count
    FROM
        [HR Employee data] ed
    LEFT JOIN
        termination_info ti 
          ON ed.EmployeeID = ti.EmployeeID
    GROUP BY
        ed.gender
)
SELECT
    gender,
    turnover_count,
    total_count,  
      CAST(turnover_count AS DECIMAL)/ total_count AS turnover_rate
FROM
    EmployeeTurnover;
