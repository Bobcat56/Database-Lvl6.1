/*
	IICT6203 - Database Programming II
	Topic 2 - User Defined Functions
	Worksheet 02 - Setup Script

*/

USE dp2;
GO

if exists (select * from sys.schemas where name='wk02')
begin
	DROP TABLE wk02.paymentLog
	DROP TABLE wk02.Payment
	DROP TABLE wk02.orderItem
	DROP TABLE wk02.[Order]
	DROP TABLE wk02.orderStatus
	DROP TABLE wk02.Product
	DROP TABLE wk02.userAccount
	DROP TABLE wk02.accountStatus
	DROP SCHEMA wk02;
end
GO

-- Creation
CREATE SCHEMA wk02;
GO

CREATE TABLE wk02.accountStatus (
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE wk02.userAccount (
	accountId INTEGER PRIMARY KEY IDENTITY(1,1),
	Username NVARCHAR(45) UNIQUE NOT NULL,
	statusId SMALLINT NOT NULL
		REFERENCES wk02.accountStatus (statusId)
);

CREATE TABLE wk02.Product (
	productId INTEGER PRIMARY KEY,
	productName NVARCHAR(45) UNIQUE NOT NULL,
	unitPrice NUMERIC(6,2) NOT NULL
);

CREATE TABLE wk02.orderStatus(
	statusId SMALLINT PRIMARY KEY IDENTITY(1,1),
	statusName NVARCHAR(45) UNIQUE NOT NULL
);

CREATE TABLE wk02.[Order] (
	orderId INTEGER PRIMARY KEY,
	orderDate DATETIMEOFFSET NOT NULL,
	accountId INTEGER NOT NULL
		REFERENCES wk02.userAccount(accountId),
	statusId SMALLINT NOT NULL
		REFERENCES wk02.orderStatus(statusId)
);

CREATE TABLE wk02.orderItem (
	productId INTEGER
		REFERENCES wk02.Product (productId),
	orderId INTEGER
		REFERENCES wk02.[Order] (orderId),
	 Quantity TINYINT NOT NULL,
	PRIMARY KEY (productId, orderId)
);

CREATE TABLE wk02.Payment (
	paymentId INTEGER PRIMARY KEY,
	paymentAmount NUMERIC(6,2) NOT NULL,
	IsValid BIT NULL,
	paymentDate DATETIMEOFFSET NULL,
	paymentMessage NVARCHAR(45) DEFAULT NULL,
	orderId INTEGER NOT NULL
		REFERENCES wk02.[Order] (orderId)
);

CREATE TABLE wk02.paymentLog (
	paymentId INTEGER PRIMARY KEY IDENTITY(1,1),
	orderId INTEGER NOT NULL,
	orderTotal NUMERIC(6,2) NOT NULL,
	paidToDate NUMERIC(6,2) NOT NULL,
	paymentAmount NUMERIC(6,2) NOT NULL,
	paymentDate DATETIMEOFFSET NOT NULL,
	paymentMessage NVARCHAR(45) DEFAULT NULL,
	IsValid BIT NOT NULL
);

-- Data
INSERT INTO wk02.accountStatus (statusName)
VALUES ('Not verified'), ('Active'), ('Locked'), ('Inactive');
GO

INSERT INTO wk02.userAccount (Username, statusId)
VALUES 
	('joeb', (SELECT statusId 
    FROM wk02.accountStatus
    WHERE statusName='Inactive')),
	('lisag', (SELECT statusId 
    FROM wk02.accountStatus
    WHERE statusName='Active')),
	('tonyz', (SELECT statusId 
    FROM wk02.accountStatus
    WHERE statusName='Active')),
	('saraht', (SELECT statusId 
    FROM wk02.accountStatus
    WHERE statusName='Locked'));
GO

INSERT INTO wk02.Product (productId, productName, unitPrice)
VALUES 
(1, 'Samsung S6 Edge', 700.00),
(2, 'Apple iPhone 6', 900.00), 
(3, 'Samsung J7', 250.00),
(4, 'Google Nexus 5', 325.00),
(5, 'One Plus X', 150.00);
GO

INSERT INTO wk02.orderStatus (statusName)
VALUES 
('Payment Pending'),
('Incomplete Payment'),
('Paid in full');
GO

INSERT INTO wk02.[Order] (orderId, orderDate, accountId, statusId)
VALUES 
(1, SYSDATETIMEOFFSET(), 
	(SELECT accountId
    FROM wk02.userAccount
    WHERE Username='joeb'),
    (SELECT statusId 
    FROM wk02.orderStatus 
    WHERE statusName='Payment Pending')),
(2, SYSDATETIMEOFFSET(), 
	(SELECT accountId
    FROM wk02.userAccount
    WHERE Username='lisag'),
    (SELECT statusId 
    FROM wk02.orderStatus 
    WHERE statusName='Payment Pending')),
(3, SYSDATETIMEOFFSET(), 
	(SELECT accountId
	FROM wk02.userAccount
    WHERE Username='lisag'),
    (SELECT statusId 
    FROM wk02.orderStatus 
    WHERE statusName='Payment Pending')),
(4, SYSDATETIMEOFFSET(), 
	(SELECT accountId
	FROM wk02.userAccount
    WHERE Username='saraht'),
    (SELECT statusId 
    FROM wk02.orderStatus 
    WHERE statusName='Payment Pending'));
GO

INSERT INTO wk02.orderItem (orderId, productId, Quantity)
VALUES (1, 2, 3), (1, 1, 2), (2, 3, 1), (2, 4, 3), (3, 4, 5), (3, 1, 1),
	(3, 2, 1), (4, 2, 1), (4, 1, 1);
GO

INSERT INTO wk02.Payment (paymentId, paymentAmount, orderId, IsValid)
VALUES 
(1, 2000.00, 1, 0),
(2, 2100.00, 1, 0),
(3, 500.00, 2, 1),
(4, 500.00, 2, 1),
(5, 500.00, 2, 0),
(6, 225.00, 2, 1),
(7, -500.00, 3, 0), 
(8, 0.00, 3, 0),
(9, 500.00, 3, 1),
(10, 500.00, 3, 1),
(11, 500.00, 3, 1),
(12, 100.00, 3, 1),
(13, 500.00, 3, 0),
(14, 3225.00, 4, 0);
GO
