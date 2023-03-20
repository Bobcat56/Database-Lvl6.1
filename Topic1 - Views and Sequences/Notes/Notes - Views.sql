/*				-- VIEWS --
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver16

-- Syntax for SQL Server and Azure SQL Database  
  
CREATE [ OR ALTER ] VIEW [ schema_name . ] view_name [ (column [ ,...n ] ) ]
[ WITH <view_attribute> [ ,...n ] ]
AS select_statement
[ WITH CHECK OPTION ]
[ ; ]  
  
<view_attribute> ::=
{  
    [ ENCRYPTION ]  
    [ SCHEMABINDING ]  
    [ VIEW_METADATA ]
}
*/

/*Question 1: Show all the different job titles per department*/
SELECT jobTitle,
	   departmentName
FROM Topic1.Job j
JOIN Topic1.Department d
ON (j.departmentId = d.departmentId)

/*Question 2: Create a view Topic.vw_dep_job*/
GO;

CREATE VIEW Topic1.vw_dep_job AS 
   SELECT jobTitle,
	      departmentName
   FROM Topic1.Job j
   JOIN Topic1.Department d
   ON (j.departmentId = d.departmentId);
GO;

/*Question 3: Show all data from the view*/
SELECT *
FROM Topic1.vw_dep_job;

/*Question 4: Add a new job IT clerk to the IT department using view*/
INSERT INTO Topic1.vw_dep_job (jobTitle, departmentName)
VALUES ('IT clerk', 'IT');
--This will not work since it effects mutiple tables.

/*Question 5: Remove the view*/
DROP VIEW Topic1.vw_dep_job;

/*Question 6: Add a view topic1.vm_emp_details that shows name, surname, jobid of all employees*/
GO;

CREATE VIEW topic1.vm_emp_details 
AS SELECT firstName,
		  lastName,
		  jobId
   FROM Topic1.Employee;
GO;

/*Question 7: Show all data from the view*/
SELECT *
FROM topic1.vm_emp_details;

/*Question 8: Add a new clerk named Tony Zammt*/
INSERT INTO Topic1.vm_emp_details (firstName, lastName, jobId)
VALUES ('Tony', 'Zammit', (SELECT jobId 
						   FROM Topic1.Job
						   WHERE jobTitle = 'Clerk'));

/*Question 9: Show all data from the view*/
SELECT *
FROM topic1.vm_emp_details;

/*Question 10: remove the view*/
DROP VIEW Topic1.vm_emp_details;

/*Question 11: Create a view topic1.vw_it_employees that shows the first name, last name, jobId 
  for all employees in the IT Department*/
GO;

CREATE VIEW topic1.vw_it_employees 
AS SELECT firstName,
	      lastName,
	      e.jobId		  --Note: Views have issues when calling different tables, so when youre able 
   FROM Topic1.Employee e      -- to call from the same table it would reduce the chance of having issues
   JOIN Topic1.Job j
   ON (e.jobId = j.jobId)
   JOIN Topic1.Department d
   ON (j.departmentId = d.departmentId)
   WHERE d.departmentName LIKE 'IT';

GO;

/*Question 12: Show data from the previous view*/
SELECT *
FROM Topic1.vw_it_employees;

/*Question 13: Add an HR Manager named Sarah Tanti using the previous view*/
INSERT INTO Topic1.vw_it_employees (firstName, lastName, jobId)
VALUES ('Sarah', 'Tanti', (SELECT jobId 
						   FROM Topic1.Job
						   WHERE jobTitle = 'HR Manager'));

/*Question 14: Show all data from the prvious query*/
SELECT *
FROM Topic1.vw_it_employees

/*Question 15: Modify the previous view so that the only rows visible can be inserted / updated / deleted*/
GO; 

CREATE OR ALTER VIEW Topic1.vw_it_employees
AS SELECT firstName,
	      lastName,
	      e.jobId		  
   FROM Topic1.Employee e
   JOIN Topic1.Job j
   ON (e.jobId = j.jobId)
   JOIN Topic1.Department d
   ON (j.departmentId = d.departmentId)
   WHERE d.departmentName LIKE 'IT'
WITH CHECK OPTION;

GO;

/*Question 16: Add Ian Muscat as a Clerk*/
INSERT INTO Topic1.vw_it_employees (firstName, lastName, jobId)
VALUES ('Ian', 'Muscat', (SELECT jobId 
						   FROM Topic1.Job
						   WHERE jobTitle = 'Clerk'));

/*Question 17: Drop the previous view*/
DROP VIEW Topic1.vw_it_employees;