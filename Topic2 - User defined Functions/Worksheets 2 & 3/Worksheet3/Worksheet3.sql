use CompanyDb;
go

select * from dbo.Country;
select * from dbo.Department;
select * from dbo.Employee;
select * from dbo.Job;
select * from dbo.jobGrade;
select * from dbo.jobHistory;
select * from dbo.Location;
select * from dbo.Region;
go

-- Question 1
create or alter function dbo.udf_SalaryDepartment(@departmentName nvarchar(50))
returns @salaryDepartment table (
	totalPeople integer,
	totalSalary numeric(10,2)
)
as
begin
	insert into @salaryDepartment
	select count(e.employeeId), sum(e.Salary)
	from dbo.Employee e inner join dbo.Job j
		on e.jobId = j.jobId
		inner join dbo.Department d
		on e.departmentId = d.departmentId
	where d.departmentName = @departmentName
	
	return;
end;
go

-- Question 2
select totalSalary as 'Total Salary', totalPeople as 'Total Employees'
from dbo.udf_SalaryDepartment('Marketing');
go

-- Question 3
create or alter function dbo.udf_CountryDepts(@country nvarchar(50))
returns integer
as 
begin
	return (
		select count(d.departmentId)
		from dbo.Department d inner join dbo.[Location] l
			on d.locationId = l.locationId
			inner join dbo.Country c
			on l.countryId = c.countryId
		where c.countryName = @country
	);
end;
go

-- Question 4
select dbo.udf_CountryDepts('Germany') as 'Total Departments';
go

-- Question 5
create or alter function dbo.udf_GradeLevel(@salary numeric(8,2))
returns char(1)
as begin
	return (
		select gradeLevel
		from dbo.jobGrade
		where @salary between lowestSal and highestSal
	);
end;
go

-- Question 6
select e.firstName as 'First Name', e.lastName as 'Last Name', j.jobTitle as 'Job Title', e.Salary, dbo.udf_GradeLevel(e.Salary) as 'Grade Level' 
from dbo.Employee e inner join dbo.Job j
	on e.jobId = j.jobId
order by 5, 4;
go

-- Question 7
create or alter function dbo.udf_isEmployeeManager(@employeeId integer)
returns nvarchar(15)
as begin
	return (
		select iif(count(*) = 0, 'Not a manager', 'Manager')
		from dbo.Employee
		where managerId = @employeeId
	);
end;
go

-- Question 8
select firstName as 'First Name', lastName as 'Last Name', dbo.udf_isEmployeeManager(e.employeeId) as 'Manager'
from dbo.Employee e;

-- Question 9
select d.departmentName as 'Department Name', c.countryName as 'Country Name', sd.totalPeople as 'Total Employees', sd.totalSalary as 'Total Salary'
from dbo.Department d cross apply dbo.udf_SalaryDepartment(d.departmentName) sd
	inner join dbo.[Location] l
	on d.locationId = l.locationId
	inner join dbo.Country c
	on l.countryId = c.countryId
group by d.departmentName, c.countryName, sd.totalPeople, sd.totalSalary
order by 3 desc;

-- Question 10
select c.countryName as 'Country Name', sum(sd.totalPeople) as 'Total Employees', sum(sd.totalSalary) as 'Total Salary'
from dbo.Department d cross apply dbo.udf_SalaryDepartment(d.departmentName) sd
	inner join dbo.[Location] l
		on d.locationId = l.locationId
	inner join dbo.Country c
		on l.countryId = c.countryId
group by c.countryName;

-- Question 11
select c.countryName as 'Country Name', count(dbo.udf_isEmployeeManager(e.employeeId)) as 'Number of Managers'
from dbo.Country c inner join dbo.[Location] l
	on c.countryId = l.countryId
	inner join dbo.Department d
	on l.locationId = d.locationId
	inner join dbo.Employee e
	on d.departmentId = e.departmentId
where dbo.udf_isEmployeeManager(e.employeeId) = 'Manager'
group by c.countryName
order by 2 desc;