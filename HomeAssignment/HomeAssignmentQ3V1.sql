/*			----	QUESTION 1		----
	This part is setting up the required structured:
	a) Create a database called a3products.
	b) Create two schemas: loading, and main.
	c) In loading schema, create the table json_data as per given ERD.
	d) In main schema, create the tables brand, category, and product as per given ERD.
*/

--				Create Database				--
CREATE DATABASE a3products;
USE a3products;
GO
		
--				Create schemas				--
CREATE SCHEMA loading;
GO

CREATE SCHEMA main;
GO

--				Table json_data				--
CREATE TABLE loading.JsonData (
	ID INT PRIMARY KEY NOT NULL,
	json_Data NVARCHAR(MAX) NOT NULL,
	date_Loaded DATETIME NOT NULL,
	date_Processed DATETIME
);

--				Table Category				--
CREATE TABLE main.Category (
    category_ID UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    category NVARCHAR(256) UNIQUE NOT NULL
);

--				Table Brand					--
CREATE TABLE main.Brand (
    brand_ID UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    brand NVARCHAR(256) UNIQUE NOT NULL
);

--				Table Product				--
CREATE TABLE main.Product (
	product_ID INT PRIMARY KEY NOT NULL,
    title NVARCHAR(100) UNIQUE NOT NULL,
    [description] NVARCHAR(MAX) NOT NULL,
    price NUMERIC(8, 2) NOT NULL,
    discounted_Percentage NUMERIC(8, 2) NOT NULL,
    rating NUMERIC(8, 2) NOT NULL,
    stock NUMERIC(8) NOT NULL,
    category_ID UNIQUEIDENTIFIER NOT NULL,
    brand_ID UNIQUEIDENTIFIER NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES main.Category(Category_ID),
    FOREIGN KEY (Brand_ID) REFERENCES main.Brand(Brand_ID) 
);
GO

/*			----	QUESTION 2		----
	Create a procedure named loading.replaceQuotes that accepts an integer as an input parameter. This 
	procedure will update the loading.json_data table for the row with the specified id (passed as a 
	parameter). The json data field should have all its single quotes replaced with double quotes.
*/

--			Procedure ReplaceQuotes			--
CREATE OR ALTER PROCEDURE loading.replaceQuotes (@ID INT)
AS BEGIN
	UPDATE loading.JsonData
	SET json_Data = REPLACE (json_Data, '''', '"')
	WHERE ID = @ID;
END;
GO

/*			----	QUESTION 3		----
	Create a procedure main.processJson that accepts an integer. This procedure must have the following 
	functionality. You can see the data in attached files products_1.json and products_2.json.
	description, price, discountedPercentage, rating, stock, brand, category.
*/
--			Procedure processJson			--
CREATE OR ALTER PROCEDURE main.processJson (@ID INT)
AS BEGIN 
	--a) Turn off row counting.
	SET NOCOUNT ON;
	
	/*b) Declare a temporary table that will store only the following fields from the JSON data: id, title, 
		 description, price, discountedPercentage, rating, stock, brand, category. */
	CREATE TABLE #tempTable (
	ID INT,
	title NVARCHAR(100) UNIQUE,
    [description] NVARCHAR(MAX),
    price NUMERIC(8, 2),
    discounted_Percentage NUMERIC(8, 2),
    rating NUMERIC(8, 2),
    stock NUMERIC(8),
	brand NVARCHAR(256),
    category NVARCHAR(256)
	);

	/*c) Find the record from loading.json_data that has an ID that matches the passed parameter, 
	     process the JSON data and store it in the temporary table.*/
	INSERT INTO #TempTable 
	(id, title, [description], price, discounted_Percentage, rating, stock, brand, category)
    SELECT JSON_VALUE(json_Data, '$.id'),
		   JSON_VALUE(json_Data, '$.title'),
		   JSON_VALUE(json_Data, '$.description'),
           JSON_VALUE(json_Data, '$.price'),
           JSON_VALUE(json_Data, '$.discountPercentage'),
           JSON_VALUE(json_Data, '$.rating'),
           JSON_VALUE(json_Data, '$.stock'),
           JSON_VALUE(json_Data, '$.brand'),
           JSON_VALUE(json_Data, '$.category')
    FROM loading.JsonData
    WHERE ID = @ID;
	
	/*d) Insert the unique brands obtained from the temporary table into the table main.brand. Make 
		 sure not to insert existing brands.*/
	DECLARE @BrandExists INT;
	DECLARE @BrandName NVARCHAR(256);
	DECLARE @UUIDBrand UNIQUEIDENTIFIER;

	SELECT @BrandExists = COUNT(*) 
	FROM #tempTable 
	WHERE brand NOT IN (SELECT brand 
						FROM main.Brand);

	SELECT @BrandName = brand 
	FROM #tempTable 
	WHERE brand NOT IN (SELECT brand 
						FROM main.Brand);

	IF @BrandExists > 0
	BEGIN
		INSERT INTO main.Brand
		VALUES (NEWID(), @BrandName);
	END;
	
	/*e) Insert the unique categories obtained from the temporary table into the table main.category. 
		 Make sure not to insert existing categories.*/
	DECLARE @CategoryExists INT;
	DECLARE @CategoryName NVARCHAR(256);
	DECLARE @UUIDCat UNIQUEIDENTIFIER;

	SELECT @CategoryExists = COUNT(*) 
	FROM #tempTable 
	WHERE category NOT IN (SELECT category 
						   FROM main.Category);

	SELECT @CategoryName = category 
		   FROM #tempTable 
		   WHERE category NOT IN (SELECT category 
						          FROM main.Category);


	IF @CategoryExists > 0
	BEGIN
		INSERT INTO main.Category
		VALUES (NEWID(), @CategoryName);
	END;
	
	/*f) Insert the products obtained from the temporary table into the table main.product. Make sure 
		 not to insert existing products (you can check this using the productid).*/
	INSERT INTO main.Product
	(product_ID, title, [description], price, discounted_Percentage, rating, stock, category_ID, brand_ID)
	SELECT ID,
		   title,
		   [description],
		   price,
		   discounted_Percentage,
		   rating,
		   stock,
		   (SELECT category_ID
		   FROM main.Category
		   WHERE category = @CategoryName),
		   (SELECT brand_ID
		   FROM main.Brand
		   WHERE brand = @BrandName)
	FROM #tempTable
	WHERE ID NOT IN (SELECT product_ID
					 FROM main.Product)
END;
GO

/*			----	QUESTION 4		----
	Create a trigger on the table loading.json_data that will fire after a record has been inserted. The 
	trigger must have the following functionalities:
*/

--			Trigger trgAfterInsert			--
CREATE OR ALTER TRIGGER trgAfterInsert
ON loading.JsonData AFTER INSERT 
AS BEGIN
	--a) Start a transaction.
	BEGIN TRANSACTION;

	--b) Set the isolation level to prevent dirty reads and nonrepeatable reads.
	SET TRANSACTION ISOLATION LEVEL 
	READ COMMITTED;

	--c) Get the ID of the inserted record.
	DECLARE @InsertedID INT;
    SELECT @InsertedID = ID FROM inserted;

	/*d) Use the ID obtained in part C and try to replace the quotes using the previously created 
		 procedure loading.replaceQuotes. This must have error handling. If not successful throw an 
		 error message with number 60001, state 1 and an appropriate message; then rollback the 
		 transaction. */
	BEGIN TRY
		EXEC loading.replaceQuotes @ID = @InsertedID;
		EXEC main.processJson @ID = @InsertedID;

	/*f) If part D and E were successful, update the date processed field in the loading.json_data table 
		  with the current time and commit the transaction. */
		UPDATE loading.JsonData
        SET Date_Processed = GETDATE()
        WHERE ID = @InsertedID;

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 
		DECLARE @ErrorMessage NVARCHAR(100) = ERROR_MESSAGE(); --Change into an appropriate error message 
		THROW 60001, @ErrorMessage, 1;
	END CATCH
END;

/*			----	QUESTION 5		----
	Create a function main.getProductsRating that accepts a rating decimal number, and it returns the 
	title, price, rating, stock, and brand for all products having a rating greater or equal to the passed 
	parameter. The return result must be formatted in JSON as shown below:

		[
		 {"title": "cereals muesli fruit nuts",
		 "price": 46,
		 "rating": 4.94,
		 "stock": 113,
		 "brand": "fauji"}
		 ,
		 {"title": "Key Holder",
		 "price": 30,
		 "rating": 4.92,
		 "stock": 54,
		 "brand": "Golden"},
		…
		]
*/