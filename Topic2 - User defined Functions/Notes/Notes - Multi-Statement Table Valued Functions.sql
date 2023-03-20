/* ----------------------------------------------- Syntax for inline table-valued function in Transact-SQL -----------------------------------------------
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ] [ type_schema_name. ] parameter_data_type [ NULL ]
    [ = default ] [ READONLY ] }
    [ ,...n ]
  ]
)
RETURNS TABLE
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    RETURN [ ( ] select_stmt [ ) ]
[ ; ]
*/

create or alter function calcs(@num1 integer, @num2 integer)
returns table
return
select
	@num1 + @num2 as 'total',
	@num1 - @num2 as 'difference',
	@num1 * @num2 as 'product',
	cast(@num1 as float) / cast(@num2 as float) as 'division'
go

select *
from dbo.calcs(2,7);

select *
from dbo.calcs(456,678);
go

-- Q1: Create a function topic2.getTotalDepartments that returns the number of departments.
create or alter function topic2.getTotalDepartments()
returns integer
as
begin
	return (
		select count(departmentId)
		from topic2.Department
	);
end;
go

select topic2.getTotalDepartments() as 'Total number of departments';
go

-- Q2: Create a query that shows how many jobs there are in the IT department.
select count(jobId) as 'Jobs in the IT department'
from topic2.Job
where departmentId = (select departmentId
                      from topic2.Department
					  where departmentName = 'IT');
-- or...
select count(j.jobId) as 'Jobs in the IT department'
from topic2.Job j inner join topic2.Department d
	on j.departmentId = d.departmentId
where d.departmentName = 'IT';
go

-- Q3: Convert the previous query into a function topic2.getJobsPerDepartment so that it accepts the department name.
create or alter function topic2.getJobsPerDepartment(@departmentName nvarchar(50))
returns integer
as
begin
	return (select count(jobId)
			from topic2.Job
			where departmentId = (select departmentId
								  from topic2.Department
								  where departmentName = @departmentName));
end;
go
-- or...
create or alter function topic2.getJobsPerDepartment(@departmentName nvarchar(50))
returns integer
as
begin
	return (select count(j.jobId)
			from topic2.Job j inner join topic2.Department d
				on j.departmentId = d.departmentId
			where d.departmentName = @departmentName);
end;
go

select topic2.getJobsPerDepartment('IT') as 'Jobs in the IT department',
	topic2.getJobsPerDepartment('HR') as 'Jobs in the HR department',
	topic2.getJobsPerDepartment('TX') as 'Jobs in the Tax department';

-- Q4: Show the job title, department name and any salary related to each job from the job history.
select j.jobTitle, d.departmentName, jh.Salary
from topic2.JobHistory jh inner join topic2.Job j
	on jh.jobId = j.jobId
	inner join topic2.Department d
	on j.departmentId = d.departmentId;
go

-- Q5: Convert the previous query into a function that accepts the minimum salary.
create or alter function topic2.getJobsGreaterThanMinimumSalary(@minimumSalary numeric(8,2))
returns table
return (select j.jobTitle, d.departmentName, jh.Salary
		from topic2.JobHistory jh inner join topic2.Job j
			on jh.jobId = j.jobId
			inner join topic2.Department d
			on j.departmentId = d.departmentId
		where jh.Salary > @minimumSalary);
go

select *
from topic2.getJobsGreaterThanMinimumSalary(15000);


/* ----------------------------------------------- Syntax for multi-statement table-valued functions in Transact-SQL -----------------------------------------------
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ] [ type_schema_name. ] parameter_data_type [ NULL ]
    [ = default ] [READONLY] }
    [ ,...n ]
  ]
)
RETURNS @return_variable TABLE <table_type_definition>
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    BEGIN
        function_body
        RETURN
    END
[ ; ]
*/

create or alter function topic2.getJobsGreaterThanMinimumSalaryV2(@minimumSalary numeric(8,2))
returns @salaryTable table (
	jobTitle nvarchar(50),
	departmentName nvarchar(50),
	salary integer
)
begin
		insert into @salaryTable
			(jobTitle, departmentName, salary)
		select j.jobTitle, d.departmentName, jh.Salary
		from topic2.JobHistory jh inner join topic2.Job j
			on jh.jobId = j.jobId
			inner join topic2.Department d
			on j.departmentId = d.departmentId
		where jh.Salary > @minimumSalary;

		-- You can have one or more operations in a multi-statement table valued function.

		return -- There is no need to indicate that you are returning the table because the function will automatically return what is declared in the returns.
end;
go

select *
from topic2.getJobsGreaterThanMinimumSalaryV2(15000);

-- Q6: Create a query to show the current salary for employees with an id of 1.
select jh.fromDate, jh.endDate, jh.Salary
from topic2.Employee e inner join topic2.JobHistory jh
	on e.employeeId = jh.employeeId
	inner join topic2.Job j
	on jh.jobId = j.jobId
where e.employeeId = 1 and jh.endDate is null
go

-- Q7: Convert the previous query into a function that accepts the employee id.
create or alter function topic2.getCurrentSalaryForEmployee(@employeeId int)
returns integer
as
begin
	return (select jh.Salary
			from topic2.Employee e inner join topic2.JobHistory jh
				on e.employeeId = jh.employeeId
				inner join topic2.Job j
				on jh.jobId = j.jobId
			where e.employeeId = @employeeId and jh.endDate is null
			order by jh.endDate desc);
end;
go

select topic2.getCurrentSalaryForEmployee(1) as 'Current salary for employee with id 1';
go

-- Q8: Create a function that returns the job history for a chosen employee. Must return departmentName, jobTitle, fromDate and endDate.
create or alter function topic2.getJobHistoryForEmployee(@employeeId integer)
returns @jobHistory table (
	departmentName nvarchar(50),
	jobTitle nvarchar(50),
	fromDate date,
	endDate date
)
as
begin
	insert into @jobHistory
	select d.departmentName, j.jobTitle, jh.fromDate, jh.endDate
	from topic2.JobHistory jh inner join topic2.Employee e
		on jh.employeeId = e.employeeId
		inner join topic2.Job j 
		on jh.jobId = j.jobId
		inner join topic2.Department d
		on j.departmentId = d.departmentId
	where e.employeeId = @employeeId

	return;
end;
go

select *
from topic2.getJobHistoryForEmployee(1);
go

-- Q9: Copy the previous function and allow for displaying or not the current job.
create or alter function topic2.getJobHistoryForEmployee2(@employeeId integer, @includeCurrent bit)
returns @jobHistory table (
	departmentName nvarchar(50),
	jobTitle nvarchar(50),
	fromDate date,
	endDate date
)
as
begin
	if(@includeCurrent = 1)
	begin
		insert into @jobHistory
			(departmentName, jobTitle, fromDate, endDate)
		select d.departmentName, j.jobTitle, jh.fromDate, jh.endDate
		from topic2.JobHistory jh inner join topic2.Employee e
			on jh.employeeId = e.employeeId
			inner join topic2.Job j 
			on jh.jobId = j.jobId
			inner join topic2.Department d
			on j.departmentId = d.departmentId
		where e.employeeId = @employeeId
	end
	else
	begin
		insert into @jobHistory
			(departmentName, jobTitle, fromDate, endDate)
		select d.departmentName, j.jobTitle, jh.fromDate, jh.endDate
		from topic2.JobHistory jh inner join topic2.Employee e
			on jh.employeeId = e.employeeId
			inner join topic2.Job j 
			on jh.jobId = j.jobId
			inner join topic2.Department d
			on j.departmentId = d.departmentId
		where e.employeeId = @employeeId
		and jh.endDate is not null;
	end
	return;
end;
go

select *
from topic2.getJobHistoryForEmployee2(1, 1);

select *
from topic2.getJobHistoryForEmployee2(1, 0);

select *
from topic2.getJobHistoryForEmployee2(2, 1);

-- Q10: Use previous function to display the history for all employees.
select e.firstName, e.lastName,
	jh.jobTitle, jh.fromDate, jh.endDate
from topic2.Employee e cross apply topic2.getJobHistoryForEmployee2(e.employeeId, 1) jh; -- Displays the job history for all employees.

-- Q11: Use the previous function to display the history for all employees. Do not include the current job.
select e.firstName, e.lastName,
	jh.jobTitle, jh.fromDate, jh.endDate
from topic2.Employee e cross apply topic2.getJobHistoryForEmployee2(e.employeeId, 0) jh;

/* Q12: Use the previous function to display the history for all employees. Do not include the current job.
 * Display all employees even if they do not have a previous job. */
select e.firstName, e.lastName,
	jh.jobTitle, jh.fromDate, jh.endDate
from topic2.Employee e outer apply topic2.getJobHistoryForEmployee2(e.employeeId, 0) jh;
go

/* Q13: Create a function that accepts an employeeId, a minimum and maximum value for salary. 
 * The function must return the salary, jobTitle and departmentName where the salary must fall between the specified range. */
create or alter function topic2.getJobsByMinAndMaxSalary(@employeeId integer, @minimumSalary integer, @maximumSalary integer)
returns @employeeInformation table (
	salary integer,
	jobTitle nvarchar(50),
	departmentName nvarchar(50)
)
as begin
	insert into @employeeInformation
	select jh.Salary, j.jobTitle, d.departmentName
	from topic2.Employee e inner join topic2.JobHistory jh
		on e.employeeId = jh.employeeId
		inner join topic2.Job j
		on jh.jobId = j.jobId
		inner join topic2.Department d
		on j.departmentId = d.departmentId
	where e.employeeId = @employeeId 
	and salary between @minimumSalary and @maximumSalary

	return;
end;
go

-- Q14: Use the previous function with the table employee to display details for all employees for salaries ranging 1000 to 15000.
select *
from topic2.Employee e cross apply topic2.getJobsByMinAndMaxSalary(e.employeeId, 1000, 15000);