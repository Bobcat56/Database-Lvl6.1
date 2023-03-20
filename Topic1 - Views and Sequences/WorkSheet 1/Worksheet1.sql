--		--			WORKSHEET 1				-- 		--

/*Question 1: Create a view that displays the status name for each username.*/
CREATE VIEW wk01.users
AS SELECT statusName,
		  username
	FROM wk01.accountStatus a
	JOIN wk01.userAccount ua
	ON (a.statusId = ua.statusId);

GO;

/*Question 2: Query the view and compare your result to the expected output in the document*/
SELECT *
FROM wk01.users

/*Question 3: Create a view that displays the list of orders that are pending payment (filter should be via a subquery). 
The view should display all attributes of the orders table only. Set the view such that any changes to the data via the 
view should be limited to the filters of the view.*/
GO;

CREATE OR ALTER VIEW wk01.view2
AS SELECT o.orderId,
		  o.orderDate,
		  o.accountId,
		  o.statusId
FROM wk01.[Order] o
JOIN wk01.orderStatus os
ON (o.statusId = os.statusId)
WHERE o.statusId = (SELECT statusId
				    FROM wk01.orderStatus
				    WHERE statusName LIKE 'Payment Pending')
GO;

/*Question 4: Query the view and compare your result to with the expected output in the document.*/
SELECT * 
FROM wk01.view2;

GO;

/*Question 5: Create a view that displays all attributes of the product table.*/
CREATE OR ALTER VIEW wk01.vwProducts
AS SELECT * 
FROM wk01.Product

GO;

/*Question 6: Create a sequence for the product id that starts from the 10 and increments by 1. The sequence should not cycle, 
caches 20 values and has no min and max value.*/
CREATE SEQUENCE wk01.seqProductId
START WITH 10
increment BY 1
NO cycle
cache 20;

GO;

/*Question 7: Insert a new product named ‘Samsung Tab 10’ priced at 500. Use the previously created view and sequence.*/
INSERT INTO wk01.vwProducts
	(productId, productName, unitPrice)
VALUES
	(
		(NEXT VALUE FOR wk01.seqProductId), -- Do not use select.
		'Samsung Tab 10',
		500
	);

GO;

/*Question 8: Create a sequence for the order id that starts from 10 and increments by 1. The sequence should not cycle, 
should have a minimum value of 0 and a maximum value of 1 million.  Values for this sequence should not be cached.*/
CREATE SEQUENCE wk01.seqOrderId
START WITH 10
increment BY 1
NO cycle
minvalue 0
maxvalue 1000000
NO cache;

GO;

/*Question 9: Use the view and sequence to create a new order by lisag. Research how to get the current date, time and offset 
of the local system and use the function to set the order date. All foreign key values should be obtained via subqueries. 
Query the orders table and compare it with the below:*/
INSERT INTO wk01.view2
	([Order ID], [Order Date], [Account ID], [Status ID])
VALUES
	(
		(NEXT VALUE FOR wk01.seqOrderId),
		SYSDATETIMEOFFSET(),
		(SELECT accountId
		 FROM wk01.userAccount
		 WHERE Username = 'lisag'),
		(SELECT statusId
		 FROM wk01.orderStatus
		 WHERE statusName = 'Payment Pending')
	);

/*Question 10: Research on how to retrieve the current value of a sequence and add two Samsung Tab 10 for the new order created
in question 9. Query the order items table and compare it with the below:*/
INSERT INTO wk01.orderItem
	(productId, orderId, Quantity)
VALUES
	(
		(SELECT CONVERT(INTEGER, current_value)
		 FROM sys.sequences
		 WHERE [name] = 'seqProductId'),
		(SELECT CONVERT(INTEGER, current_value)
		 FROM sys.sequences
		 WHERE [name] = 'seqOrderId'),
		 2
	);

GO; 

/*Question 11: Use the view created in question 3 to insert a new order placed by lisag.  The order should have a ‘Paid in full’
status.  Make sure to use subqueries to obtain any values of foreign keys. Observe the outcome and discuss.*/
INSERT INTO wk01.view2
	([Order ID], [Order Date], [Account ID], [Status ID])
VALUES
	(
		(NEXT VALUE FOR wk01.seqOrderId),
		SYSDATETIMEOFFSET(),
		(SELECT accountId
		 FROM wk01.userAccount
		 WHERE Username = 'lisag'),
		(SELECT statusId
		 FROM wk01.orderStatus
		 WHERE statusName = 'Paid in full')
	);

-- While the newly inserted record is visible in the query with joins, the record is not in wk01.vwPendingPayments because the view only displays orders with payment still pending.
SELECT *
FROM wk01.view2;

SELECT ua.username, o.orderId, o.orderDate, os.statusName
FROM wk01.userAccount ua 
INNER JOIN wk01.[order] o
ON(ua.accountId = o.accountId)
INNER JOIN wk01.orderStatus os
ON (o.statusId = os.statusId);