/*
	IICT6203 - Database Programming II
	Lesson - User Defined Functions (Database Structure)
*/

USE master;
GO

if exists (select * from sys.databases where name='dp2')
begin
	use master;
	DROP DATABASE dp2;
end
GO

--creation
CREATE DATABASE dp2;
GO

USE dp2;
GO

-- Creation
CREATE SCHEMA Topic2;
GO

CREATE TABLE Topic2.Department (
	departmentId SMALLINT PRIMARY KEY IDENTITY(1,1),
	departmentName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE Topic2.Job (
	jobId SMALLINT PRIMARY KEY IDENTITY(1,1),
	jobTitle NVARCHAR(45) UNIQUE NOT NULL,
	departmentId SMALLINT NOT NULL 
		REFERENCES Topic2.Department (departmentId)
);

CREATE TABLE Topic2.Employee (
	employeeId INTEGER PRIMARY KEY IDENTITY(1,1),
	firstName NVARCHAR(45) NOT NULL,
	lastName NVARCHAR(45) NOT NULL,
	gender CHAR DEFAULT NULL
);

CREATE TABLE Topic2.JobHistory(
	entryId INTEGER PRIMARY KEY IDENTITY(1,1),
	fromDate DATE NOT NULL,
	endDate DATE DEFAULT NULL,
	Salary NUMERIC(6,0) NOT NULL,
	jobId SMALLINT NOT NULL
		REFERENCES Topic2.Job (jobId),
	employeeId INTEGER noT NULL
		REFERENCES Topic2.Employee (employeeId)
);

-- Data population
INSERT INTO Topic2.Department (departmentName)
VALUES	('IT')
		, ('HR')
		, ('R&D');

INSERT INTO  Topic2.Job (jobTitle, departmentId)
VALUES ('Developer', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='IT'))
		, ('Network Administrator', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='IT'))
		, ('Clerk', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='HR'))
		, ('IT Manager', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='IT'))
		, ('HR Manager', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='HR'))
		,('Junior Network Administator', (SELECT departmentId FROM Topic2.Department
						WHERE departmentName='IT'));

INSERT INTO Topic2.Employee (firstName, lastName, gender)
VALUES ('Joe', 'Borg', 'M')
		, ('Lisa', 'Abela', 'F')
		, ('Tony', 'Zammit', 'M')
		, ('Sarah', 'Tanti', 'F');
GO

INSERT INTO Topic2.JobHistory (fromDate, endDate, Salary, jobId, employeeId)
VALUES ('2000-01-01', '2010-12-31', 15000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='Developer')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Joe' AND lastName='Borg'))
		,('2011-01-01', NULL, 20000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='IT Manager')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Joe' AND lastName='Borg'))
		,('2005-05-16', '2012-12-31', 12000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='Junior Network Administator')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Lisa' AND lastName='Abela'))
		,('2013-01-01', NULL, 22000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='Network Administrator')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Lisa' AND lastName='Abela'))
		,('2000-01-01', '2011-12-31', 11000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='Clerk')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Tony' AND lastName='Zammit'))
		,('2012-01-01', NULL, 19000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='HR Manager')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Tony' AND lastName='Zammit'))
		,('2012-05-31', NULL, 12000 
		, (SELECT jobId FROM Topic2.Job WHERE jobTitle='Clerk')
		, (SELECT employeeId FROM Topic2.Employee WHERE firstName='Sarah' AND lastName='Tanti'));
GO