/*
	IICT6203 - Database Programming II
	Topic 4 - Triggers
	Worksheet 05 - Setup Script

*/
use dp2;
go

if exists (select * from sys.schemas where name='wk05')
begin
DROP TABLE wk05.[Statistics];
DROP TABLE wk05.[OrderList];
DROP TABLE wk05.[Product]
DROP TABLE wk05.[Order];
drop sequence wk05.seq_Order;
DROP SCHEMA wk05;
end;
go

CREATE SCHEMA wk05;
GO

CREATE TABLE wk05.Product (
	productId INTEGER PRIMARY KEY IDENTITY,
	Product NVARCHAR(75) NOT NULL,
	Price NUMERIC(6,2) NOt NuLL,
	Quantity INTEGER NOT NULL
);

CREATE TABLE wk05.[Order] (
	orderId INTEGER PRIMARY KEY ,
	orderDate DATETIME2 NOT NULL
);

CREATE TABLE wk05.OrderList (
	productId INTEGER REFERENCES wk05.Product(productId),
	orderId INTEGER REFERENCES wk05.[Order](orderId),
	Quantity INTEGER,
	PRIMARY KEY(productId,orderId)
);

CREATE TABLE wk05.[Statistics] (
	productId INTEGER,
	[Year] INTEGER,
	totalValue NUMERIC(8,2) NOT NULL,
	totalQuantity INTEGER NOT NULL,
	PRIMARY KEY(productId,[Year])
);

INSERT INTO wk05.Product(Product, Price, Quantity)
VALUES
	('Nachos',1.5,143),
	('Cola Drink',0.75,1240),
	('Crisps',0.50,124),
	('Green Olives',2.30,100),
	('Party Hats',1.40,22),
	('Table Water',2.50,1555),
	('Mature Cheddar',3.10,93),
	('Water Crackers',2.10,22);

	
CREATE SEQUENCE wk05.seq_Order AS INT
	START WITH 1
	INCREMENT BY 1;

INSERT INTO wk05.[Order](orderId,orderDate)
VALUES
	(NEXT VALUE FOR wk05.seq_Order,'20160506 10:10:05'),
	(NEXT VALUE FOR wk05.seq_Order,'20160510 16:15:56'),
	(NEXT VALUE FOR wk05.seq_Order,'20160611 8:10:10'),
	(NEXT VALUE FOR wk05.seq_Order,'20160612 9:15:15'),
	(NEXT VALUE FOR wk05.seq_Order,'20160629 16:16:20');

INSERT INTO wk05.[OrderList](productId,orderId,Quantity)
VALUES
( (SELECT productId FROM wk05.Product WHERE Product = 'Party Hats'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160506 10:10:05'),
  4
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Crisps'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160506 10:10:05'),
  3
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Cola Drink'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160506 10:10:05'),
  2
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Mature Cheddar'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160510 16:15:56'),
  1
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Water Crackers'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160510 16:15:56'),
  1
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Green Olives'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160611 8:10:10'),
  1
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Nachos'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160612 9:15:15'),
  5
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Cola Drink'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160612 9:15:15'),
  12
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Crisps'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160612 9:15:15'),
  6
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Table Water'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160612 9:15:15'),
  20
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Party Hats'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160629 16:16:20'),
  12
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Green Olives'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160629 16:16:20'),
  5
),
( (SELECT productId FROM wk05.Product WHERE Product = 'Cola Drink'),
  (SELECT orderId FROM wk05.[Order] WHERE orderDate='20160629 16:16:20'),
  2
);

