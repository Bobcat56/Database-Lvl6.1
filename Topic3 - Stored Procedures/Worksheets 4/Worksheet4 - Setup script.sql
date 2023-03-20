/*
	IICT6203 - Database Programming II
	Lesson 3 - Stored Procedures
	Worksheet 04 - Setup Script

*/

use dp2;
go

if exists (select * from sys.schemas where name = 'wk04')
begin
	DROP TABLE wk04.paymentLog;
	DROP TABLE wk04.payment;
	DROP TABLE wk04.orderItem;
	DROP TABLE wk04.product;
	DROP TABLE wk04.[Order];
	DROP TABLE wk04.orderStatus;
	DROP TABLE wk04.userAccount;
	DROP TABLE wk04.accountStatus;
	drop schema wk04;
end
go

-- Creation
CREATE SCHEMA wk04;
GO

CREATE TABLE wk04.accountStatus 
(
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE wk04.userAccount 
(
	accountId INTEGER PRIMARY KEY IDENTITY(1,1),
	username NVARCHAR(45) UNIQUE NOT NULL,
	statusId SMALLINT
		REFERENCES wk04.accountStatus (statusId)
		NOT NULL
);

CREATE TABLE wk04.product 
(
	productId INTEGER PRIMARY KEY,
	productName NVARCHAR(45) UNIQUE NOT NULL,
	unitPrice NUMERIC(6,2) NOT NULL
);

CREATE TABLE wk04.orderStatus
(
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE wk04.[Order] 
(
	orderId INTEGER PRIMARY KEY,
	orderDate DATETIMEOFFSET NOT NULL,
	accountId INTEGER
		REFERENCES wk04.userAccount(accountId)
		NOT NULL,
	statusId SMALLINT
		REFERENCES wk04.orderStatus(statusId)
		NOT NULL
);

CREATE TABLE wk04.orderItem 
(
	productId INTEGER
		REFERENCES wk04.product (productId),
	orderId INTEGER
		REFERENCES wk04.[Order] (orderId),
	Quantity TINYINT NOT NULL,
	PRIMARY KEY (productId, orderId)
);

CREATE TABLE wk04.payment 
(
	paymentId INTEGER PRIMARY KEY,
	paymentAmount NUMERIC(6,2) NOT NULL,
	paymentDate DATETIMEOFFSET NOT NULL,
	orderId INTEGER
		REFERENCES wk04.[Order] (orderId)
		NOT NULL
);

CREATE TABLE wk04.paymentLog 
(
	entryId BIGINT PRIMARY KEY IDENTITY(1,1),
	paymentId INTEGER,
	orderId INTEGER,
	orderTotal NUMERIC(6,2),
	paidToDate NUMERIC(6,2),
	paymentAmount NUMERIC(6,2) NOT NULL,
	paymentDate DATETIMEOFFSET NOT NULL,
	IsValid BIT NOT NULL,
	paymentMessage NVARCHAR(45) DEFAULT NULL
);

-- Data
INSERT INTO wk04.accountStatus (statusName)
VALUES ('Not verified'), ('Active'), ('Locked'), ('Inactive');
GO

INSERT INTO wk04.userAccount (username, statusId)
VALUES 
	('joeb', (SELECT statusId 
	FROM wk04.accountStatus
	WHERE statusName='Inactive')),
	('lisag', (SELECT statusId 
	FROM wk04.accountStatus
	WHERE statusName='Active')),
	('tonyz', (SELECT statusId 
	FROM wk04.accountStatus
	WHERE statusName='Active')),
	('saraht', (SELECT statusId 
	FROM wk04.accountStatus
	WHERE statusName='Locked'));
GO

INSERT INTO wk04.product (productId, productName, unitPrice)
VALUES 
(1, 'Samsung S6 Edge', 700.00),
(2, 'Apple iPhone 6', 900.00),
(3, 'Samsung J7', 250.00),
(4, 'Google Nexus 5', 325.00),
(5, 'One Plus X', 150.00);
GO

INSERT INTO wk04.orderStatus (statusName)
VALUES ('Payment Pending'), ('Paid in full');
GO

INSERT INTO wk04.[Order] (orderId, orderDate, accountId, statusId)
VALUES (1, SYSDATETIMEOFFSET(), (SELECT accountId
                                 FROM wk04.userAccount
                                 WHERE username='joeb'),
        (SELECT statusId 
        FROM wk04.orderStatus 
        WHERE statusName='Payment Pending'));
                              
INSERT INTO wk04.[Order] (orderId, orderDate, accountId, statusId)
VALUES (2, SYSDATETIMEOFFSET(), (SELECT accountId
                                 FROM wk04.userAccount
                                 WHERE username='lisag'),
        (SELECT statusId 
        FROM wk04.orderStatus 
        WHERE statusName='Paid in full'));
                              
INSERT INTO wk04.[Order] (orderId, orderDate, accountId, statusId)
VALUES (3, SYSDATETIMEOFFSET(), (SELECT accountId
                                 FROM wk04.userAccount
                                 WHERE username='lisag'),
        (SELECT statusId 
        FROM wk04.orderStatus 
        WHERE statusName='Payment Pending'));
                              
INSERT INTO wk04.[Order] (orderId, orderDate, accountId, statusId)
VALUES (4, SYSDATETIMEOFFSET(), (SELECT accountId
                                 FROM wk04.userAccount
                                 WHERE username='saraht'),
        (SELECT statusId 
        FROM wk04.orderStatus 
        WHERE statusName='Payment Pending'));
GO

INSERT INTO wk04.orderItem (orderId, productId, quantity)
VALUES (1, 2, 3), (1, 1, 2), (2, 3, 1), (2, 4, 3), (3, 4, 5),
	(3, 1, 1), (3, 2, 1), (4, 2, 1), (4, 1, 1);
GO


INSERT INTO wk04.payment (paymentId, paymentAmount, paymentDate, orderId)
VALUES 
(3, 500.00, SYSDATETIMEOFFSET(), 2),
(4, 500.00, SYSDATETIMEOFFSET(), 2),
(6, 225.00, SYSDATETIMEOFFSET(), 2),
(9, 500.00, SYSDATETIMEOFFSET(), 3),
(10, 500.00, SYSDATETIMEOFFSET(), 3),
(11, 500.00, SYSDATETIMEOFFSET(), 3),
(12, 100.00, SYSDATETIMEOFFSET(), 3);

GO
