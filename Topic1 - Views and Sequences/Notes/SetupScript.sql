/*
	IICT6203 - Database Programming II
	Lesson - Views and Sequences (Database Structure)
*/

USE master;
GO

--cleanup

if exists (select 1 from sys.databases where name = 'dp2')
begin
	use master;
	drop database dp2;
end
GO

create database dp2;
go

USE dp2;
GO

CREATE SCHEMA Topic1;
GO

CREATE TABLE Topic1.Department
(
	departmentId SMALLINT PRIMARY KEY IDENTITY(1,1),
	departmentName NVARCHAR(45) NOT NULL UNIQUE
)
GO

CREATE TABLE Topic1.Job
(
	jobId SMALLINT PRIMARY KEY IDENTITY(1,1),
	jobTitle NVARCHAR(45) NOT NULL UNIQUE,
	departmentId SMALLINT NOT NULL REFERENCES Topic1.Department(departmentId)
)
GO

CREATE TABLE Topic1.Employee
(
	employeeId INTEGER PRIMARY KEY IDENTITY(1,1),
	firstName NVARCHAR(45) NOT NULL,
	lastName NVARCHAR(45) NOT NULL,
	gender CHAR(1),
	jobId SMALLINT NOT NULL REFERENCES Topic1.Job(jobId)
)
GO


INSERT INTO Topic1.Department (departmentName)
VALUES	('IT'), ('HR'), ('R&D');


INSERT INTO  Topic1.Job (jobTitle, departmentId)
VALUES ('Developer', (SELECT departmentId 
                      FROM Topic1.Department
					  WHERE departmentName='IT')),
		('Network Administrator', (SELECT departmentId 
                                  FROM Topic1.Department
					              WHERE departmentName='IT')),
		('Clerk', (SELECT departmentId 
                   FROM Topic1.Department
				   WHERE departmentName = 'HR')),
		('IT Manager', (SELECT departmentId 
                        FROM Topic1.Department
					    WHERE departmentName='IT')),
		('HR Manager', (SELECT departmentId 
                        FROM Topic1.Department
					    WHERE departmentName='HR'));


INSERT INTO Topic1.Employee (firstName, lastName, [gender], jobId)
VALUES ('Joe', 'Borg', 'M', (SELECT jobId 
                             FROM Topic1.Job
							 WHERE jobTitle = 'IT Manager')),
	   ('Lisa', 'Abela', 'F', (SELECT jobId 
                               FROM Topic1.Job
							    WHERE jobTitle ='Developer'));
GO