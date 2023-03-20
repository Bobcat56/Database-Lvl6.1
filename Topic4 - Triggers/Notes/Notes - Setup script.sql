/*
	IICT6203 - Database Programming II
	Lesson - Triggers (Database Structure)
*/

if exists (select * from sys.databases where name ='dp2')
begin
	use master;
	drop database dp2;
end

create database dp2;
go

use dp2; 
go

CREATE SCHEMA Topic4;
GO

CREATE TABLE Topic4.userAccount (
	accountId INTEGER PRIMARY KEY IDENTITY(1,1),
	accountUsername NVARCHAR(356) UNIQUE NOT NULL
);

CREATE TABLE Topic4.userProfile (
	accountId INTEGER PRIMARY KEY
		REFERENCES Topic4.userAccount (accountId),
	firstName NVARCHAR(45) NOT NULL,
	lastName NVARCHAR(45) NOT NULL,
	Avatar NVARCHAR(3058) DEFAULT NULL
);

CREATE TABLE Topic4.auditLog (
	entryId INTEGER PRIMARY KEY IDENTITY(1,1),
	entryDate DATETIMEOFFSET NOT NULL,
	accountUsername NVARCHAR(356) NOT NULL,
	action NVARCHAR(256) NOT NULL
);
GO

-- Data Population
INSERT INTO Topic4.userAccount	(accountUsername)
VALUES ('joeb') ,('lisag') ,('tonyz'), ('saraht'), ('alexb'), ('iand');

INSERT INTO Topic4.userProfile (accountId, firstName, lastName)
VALUES ((SELECT accountId FROM Topic4.userAccount WHERE accountUsername='joeb')
			,'Joe', 'Borg')
		, ((SELECT accountId FROM Topic4.userAccount WHERE accountUsername='lisag')
			,'Lisa', 'Galea')
		, ((SELECT accountId FROM Topic4.userAccount WHERE accountUsername='tonyz')
			,'Tony', 'Zammit');
GO
