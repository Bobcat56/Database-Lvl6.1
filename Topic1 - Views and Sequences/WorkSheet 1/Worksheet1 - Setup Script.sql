/*
	IICT6203 - Database Programming II
	Lesson 1 - Views and Sequences 
	Worksheet 01 - Setup Script

*/

USE dp2;
GO

if exists (select * from sys.schemas where name='wk01')
begin
	drop table wk01.orderItem;
	drop table wk01.product;
	drop table wk01.payment;
	drop table wk01.[order];
	drop table wk01.orderStatus;
	drop table wk01.userAccount;
	drop table wk01.accountStatus;
	drop table wk01.paymentLog;
	drop schema wk01;
end
go

-- Creation
CREATE SCHEMA [wk01];
GO

CREATE TABLE [wk01].accountStatus
(
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE [wk01].userAccount 
(
	accountId INTEGER PRIMARY KEY IDENTITY(1,1),
	username NVARCHAR(45) UNIQUE NOT NULL,
	statusId SMALLINT
		      REFERENCES [wk01].accountStatus(statusId)
		      NOT NULL
);

CREATE TABLE [wk01].[Product] 
(
	productId INTEGER PRIMARY KEY,
	productName NVARCHAR(45) UNIQUE NOT NULL,
	unitPrice NUMERIC(6,2) NOT NULL
);

CREATE TABLE [wk01].orderStatus
(
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE [wk01].[Order] 
(
	orderId INTEGER PRIMARY KEY,
	orderDate DATETIMEOFFSET NOT NULL,
	accountId INTEGER
		       REFERENCES [wk01].userAccount(accountId)
		       NOT NULL,
	statusId SMALLINT
		      REFERENCES [wk01].orderStatus(statusId)
		      NOT NULL
);

CREATE TABLE [wk01].orderItem 
(
	productId INTEGER
		       REFERENCES [wk01].[Product] (productId),
	orderId INTEGER
		       REFERENCES [wk01].[Order] (orderId),
	[Quantity] TINYINT NOT NULL,
	PRIMARY KEY (productId, orderId)
);

CREATE TABLE [wk01].[Payment] 
(
	paymentId INTEGER PRIMARY KEY IDENTITY(1,1),
	paymentAmount NUMERIC(6,2) NOT NULL,
	isValid BIT NOT NULL,
	paymentDate DATETIMEOFFSET NOT NULL,
    paymentMessage NVARCHAR(45) DEFAULT NULL,
	orderId INTEGER
		     REFERENCES [wk01].[Order] (orderId)
		     NOT NULL
);

CREATE TABLE [wk01].paymentLog
(
	paymentId INTEGER PRIMARY KEY IDENTITY(1,1),
	orderId INTEGER NOT NULL,
	orderTotal NUMERIC(6,2) NOT NULL,
	paidToDate NUMERIC(6,2) NOT NULL,
	paymentAmount NUMERIC(6,2) NOT NULL,
	paymentDate DATETIMEOFFSET NOT NULL,
	isValid BIT NOT NULL,
	paymentMessage NVARCHAR(45) DEFAULT NULL
);

-- Data
INSERT INTO [wk01].accountStatus(statusName)
VALUES ('Not verified'), ('Active'), ('Locked'), ('Inactive');
GO

INSERT INTO [wk01].userAccount (username, statusId)
VALUES 
	('joeb', (SELECT statusId 
	FROM [wk01].accountStatus
    WHERE statusName='Inactive')),
	('lisag', (SELECT statusId 
	FROM [wk01].accountStatus
	WHERE statusName='Active')),
	('tonyz', (SELECT statusId 
    FROM [wk01].accountStatus
    WHERE statusName='Active')),
	('saraht', (SELECT statusId 
    FROM [wk01].accountStatus
    WHERE statusName='Locked'));
GO

INSERT INTO [wk01].[Product] (productId, productName, unitPrice)
VALUES (1, 'Samsung S6 Edge', 700.00), 
(2, 'Apple iPhone 6', 900.00), 
(3, 'Samsung J7', 250.00),
(4, 'Google Nexus 5', 325.00), 
(5, 'One Plus X', 150.00);
GO

INSERT INTO [wk01].orderStatus (statusName)
VALUES ('Payment Pending'),('Incomplete Payment'),('Paid in full');
GO

INSERT INTO [wk01].[Order] (orderId, orderDate, accountId, statusId)
VALUES 
	(1, SYSDATETIMEOFFSET(), (SELECT accountId
	FROM [wk01].userAccount
    WHERE username='joeb'),
        (SELECT statusId 
        FROM [wk01].orderStatus 
        WHERE statusName='Payment Pending')),
	(2, SYSDATETIMEOFFSET(), (SELECT accountId
	FROM [wk01].userAccount
	WHERE username='lisag'),
        (SELECT statusId 
        FROM [wk01].orderStatus 
        WHERE statusName='Payment Pending')), 
	(3, SYSDATETIMEOFFSET(), (SELECT accountId
		FROM [wk01].userAccount
		WHERE username='tonyz'),
        (SELECT statusId 
        FROM [wk01].orderStatus 
        WHERE statusName='Payment Pending')),
	(4, SYSDATETIMEOFFSET(), (SELECT accountId
		FROM [wk01].userAccount
		WHERE username='saraht'),
        (SELECT statusId 
        FROM [wk01].orderStatus 
        WHERE statusName='Payment Pending'));
GO

INSERT INTO [wk01].orderItem (orderId, productId, [Quantity])
VALUES (1, 2, 3), (1, 1, 2), (2, 3, 1), (2, 4, 3), (3, 4, 5), 
	(3, 1, 1), (3, 2, 1), (4, 2, 1), (4, 1, 1);
GO
