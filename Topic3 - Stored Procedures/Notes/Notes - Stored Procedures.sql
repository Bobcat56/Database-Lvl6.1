-- Stored Procedures

/* Functions												Stored Procedures
   -------------------------------------------------------------------------------------------------------
   Must return a value (scalar or table).					May or may not return a value.
   -------------------------------------------------------------------------------------------------------
   They can only have input parameters.						They can have both input and output parameters.
															Output parameters use OUT declaration.
   -------------------------------------------------------------------------------------------------------
   Cannot use error handling (try-catch).					Can use error handling (try-catch).
   -------------------------------------------------------------------------------------------------------
   Does not allow DML (Data Manipulation Language),			Everything is allowed.
   nor DDL (Data Definition Language).
   Only insert and select operations on variable tables.
   -------------------------------------------------------------------------------------------------------
   A function cannot call a procedure.						Can call both functions and stored procedures.
   A function can call another function.
   -------------------------------------------------------------------------------------------------------
   Cannot run independently.								Can run independently.
   Must always be used with select statements.
   -------------------------------------------------------------------------------------------------------
*/
 
/* Syntax for how to create a stored procedure in T-SQL: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver16
CREATE [ OR ALTER ] { PROC | PROCEDURE }
    [schema_name.] procedure_name [ ; number ]
    [ { @parameter_name [ type_schema_name. ] data_type }
        [ VARYING ] [ NULL ] [ = default ] [ OUT | OUTPUT | [READONLY]
    ] [ ,...n ]
[ WITH <procedure_option> [ ,...n ] ]
[ FOR REPLICATION ]
AS { [ BEGIN ] sql_statement [;] [ ...n ] [ END ] }
[;]

<procedure_option> ::=
    [ ENCRYPTION ]
    [ RECOMPILE ]
    [ EXECUTE AS Clause ]*/

use dp2;
go

create table topic3.product (
    productId integer identity(1,1) primary key,
    productName nvarchar(100) not null,
    productPrice numeric(6,2) not null,
    hasDiscount bit not null
);
go

create or alter procedure topic3.addProduct
	(@name nvarchar(100), @price numeric(6,2), @discount bit)
as begin
	insert into topic3.product
		(productName, productPrice, hasDiscount)
	values
		(@name, @price, @discount);
end;
go

select * from topic3.product;

topic3.addProduct 'Twistees', 0.90, 0; -- Adding Twistees costing 90c without discount.

select * from topic3.product;

/* It is preferred to use exec before the procedure.
 * If parameters are closed in parenthesis (), the procedure will not work. */
exec topic3.addProduct 'Pringles', 1.50, 1; -- Adding Pringles costing 1.50 with discount.

select * from topic3.product;
go

-- Q2: Create a procedure that accepts a discount parameter and shows the product and price that correspond to the discount.
create or alter procedure topic3.showProductsWithDiscount(@discount bit)
as begin
	select productName, productPrice
	from topic3.product
	where hasDiscount = @discount
end;
go

exec topic3.showProductsWithDiscount 0;
go

exec topic3.showProductsWithDiscount 1;
go

-- Q3: Create a procedure that returns the total number of products into a variable.
create or alter procedure topic3.getTotalNumberOfProducts(@totalNumberOfProducts integer output)
as begin
	select @totalNumberOfProducts = count(*)
	from topic3.product;
end;

begin
	declare @total integer;
	exec topic3.getTotalNumberOfProducts @total output;
	print @total;
end
go

-- Q4: Modify the previous query to accept discount check.
create or alter procedure topic3.getTotalNumberOfProducts
	(@discount bit, @totalNumberOfProducts integer output)
as begin
	select @totalNumberOfProducts = count(*)
	from topic3.product
	where hasDiscount = @discount;
end;

begin
	declare @total integer;
	exec topic3.getTotalNumberOfProducts 0, @total output;
	print @total;
end
go

-- Q5: Modify the addProduct procedure to return the newly inserted id.
create or alter procedure topic3.addProduct
	(@name nvarchar(100), @price numeric(6,2), @discount bit,
	 @newid integer output)
as begin
	insert into topic3.product
		(productName, productPrice, hasDiscount)
	values
		(@name, @price, @discount);

	select @newId = scope_identity(); -- Returns last identity that was generated.
end;
go

begin
	declare @newId integer;
	exec topic3.addProduct 'French Fries', 1.10, 0, @newId out;
	print @newId;
end;

select * from topic3.product;