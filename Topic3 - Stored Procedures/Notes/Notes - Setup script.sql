/*
	IICT6203 - Database Programming II
	Lesson -  Stored Procedure (Setup Script)
*/

USE dp2;
GO

if exists (select * from sys.databases where name='dp2')
begin
	use master;
	drop database dp2;
end;

create database dp2;
go

use dp2;
go
--create schema
CREATE SCHEMA Topic3;
GO


CREATE TABLE Topic3.accountStatus 
(
	statusId TINYINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE Topic3.userAccount 
(
	accountId INTEGER PRIMARY KEY IDENTITY(1,1),
	accountUsername NVARCHAR(45) UNIQUE NOT NULL,
	statusId TINYINT NOT NULL REFERENCES Topic3.accountStatus(statusId)
		
);

CREATE TABLE Topic3.sessionLog 
(
	entryId BIGINT PRIMARY KEY IDENTITY(1,1),
	entryDate DATETIMEOFFSET NOT NULL,
	isLogin BIT NOT NULL,
	sessionId BIGINT NOT NULL,
	accountId INTEGER NOT NULL 	REFERENCES Topic3.userAccount(accountId)	
);

CREATE TABLE Topic3.sessionAudit
 (
	auditId BIGINT PRIMARY KEY IDENTITY(1,1),
	auditDate DATETIMEOFFSET NOT NULL,
	isLogin BIT NOT NULL,
	isSuccessful BIT NOT NULL,
	sessionId BIGINT,
	loginMessage NVARCHAR(45) DEFAULT NULL,
	accountUsername NVARCHAR(45) NOT NULL
);
GO

-- Population
INSERT INTO Topic3.accountStatus (statusName)
VALUES ('Active'), ('Locked'), ('Not Verified'), ('Closed');

INSERT INTO  Topic3.userAccount (accountUsername, statusId)
VALUES ('joeb', (SELECT statusId
                 FROM Topic3.accountStatus
			     WHERE statusName = 'Active'));

INSERT INTO Topic3.userAccount (accountUsername, statusId)
VALUES ('lisag', (SELECT statusId 
                  FROM Topic3.accountStatus
				  WHERE statusName = 'Active'));

INSERT INTO Topic3.userAccount (accountUsername, statusId)
VALUES ('tonyz', (SELECT statusId
                  FROM Topic3.accountStatus
				  WHERE statusName = 'Closed'));
GO

