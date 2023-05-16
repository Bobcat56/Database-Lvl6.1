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
CREATE TABLE loading.Json_data (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	json_Data NVARCHAR(MAX) NOT NULL,
	date_Loaded DATETIME NOT NULL,
	date_Processed DATETIME
);

--				Table Category				--
CREATE TABLE main.Category (
    category_ID UNIQUEIDENTIFIER PRIMARY KEY,
    category NVARCHAR(256) UNIQUE NOT NULL
);

INSERT INTO main.Category (category_ID, category)
VALUES ('71FDD98B-2D3A-4E11-B96B-85B7F8C64A11', 'Electronics'),
	   ('ED6B7A64-9F6E-4C1D-9D1E-2A2C7D8F977E', 'Clothing'),
	   ('B4F0DFFC-8AB7-42D2-BDCE-C61ED0A8D1F1', 'Home & Kitchen');

--				Table Brand					--
CREATE TABLE main.Brand (
    brand_ID UNIQUEIDENTIFIER PRIMARY KEY,
    brand NVARCHAR(256) UNIQUE NOT NULL
);

INSERT INTO main.Brand (brand_ID, brand)
VALUES ('8B628D8F-0EEB-417C-8D22-8A5B82B22E35', 'Samsung'),
	   ('D749A9C3-5AEB-4B6D-B28C-BB9F9C37B3C7', 'Nike'),
	   ('2F8A0155-B0FD-457A-8AF6-33B0F064A225', 'KitchenAid');


--				Table Product				--
CREATE TABLE main.Product (
	product_ID INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(100) UNIQUE NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
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
	UPDATE loading.Json_data
	SET Json_Data = REPLACE (json_Data, '''', '"')
	WHERE ID = @ID;
END;
GO

/*			----	QUESTION 3		----
	Create a procedure main.processJson that accepts an integer. This procedure must have the following 
	functionality. You can see the data in attached files products_1.json and products_2.json.
	description, price, discountedPercentage, rating, stock, brand, category.
*/

CREATE OR ALTER PROCEDURE main.processJson (@ID INT)
AS BEGIN 
	--a) Turn off row counting.
	SET NOCOUNT ON;
	
	--b) Declare a temporary table that will store only the following fields from the JSON data: id, title, 
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
    SELECT JSON_VALUE(Json_Data, '$.id'),
		   JSON_VALUE(Json_Data, '$.title'),
		   JSON_VALUE(Json_Data, '$.description'),
           JSON_VALUE(Json_Data, '$.price'),
           JSON_VALUE(Json_Data, '$.discountedPercentage'),
           JSON_VALUE(Json_Data, '$.rating'),
           JSON_VALUE(Json_Data, '$.stock'),
           JSON_VALUE(Json_Data, '$.brand'),
           JSON_VALUE(Json_Data, '$.category')
    FROM loading.json_data
    WHERE ID = @ID;

	/*d) Insert the unique brands obtained from the temporary table into the table main.brand. Make 
		 sure not to insert existing brands.*/
	INSERT INTO main.Brand (brand)
	SELECT DISTINCT brand
	FROM #tempTable
	WHERE brand NOT IN (SELECT brand
						FROM main.Brand)


	/*e) Insert the unique categories obtained from the temporary table into the table main.category. 
		 Make sure not to insert existing categories.*/
	INSERT INTO main.Category(category)
	SELECT DISTINCT category
	FROM #tempTable
	WHERE category NOT IN (SELECT category
						   FROM main.Category)


	/*f) Insert the products obtained from the temporary table into the table main.product. Make sure 
		 not to insert existing products (you can check this using the productid).*/
	INSERT INTO main.Product
	(product_ID, title, [description], price, discounted_Percentage, rating, stock, category_ID, brand_ID)
	SELECT id,
		   title,
		   [description],
		   price,
		   discounted_Percentage,
		   rating,
		   stock,
		   --Getting category ID
		  (SELECT category_ID
		   FROM main.Category
		   WHERE Category.category = #tempTable.category),
		   --Getting brand ID
		  (SELECT brand
		   FROM main.Brand
		   WHERE Brand.brand = #tempTable.brand)
	FROM #tempTable
	WHERE ID NOT IN (SELECT product_ID
					 FROM main.Product)
END;
GO

/*			----	QUESTION 4		----
	Create a trigger on the table loading.json_data that will fire after a record has been inserted. The 
	trigger must have the following functionalities:
*/

CREATE OR ALTER TRIGGER trg
ON loading.JsonData
AFTER INSERT 

END;
