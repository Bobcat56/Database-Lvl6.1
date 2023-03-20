use dp2;
go

-- Triggers (Transact-SQL): https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver16

/* Syntax for triggers in Transact-SQL:
	CREATE [ OR ALTER ] TRIGGER [ schema_name . ]trigger_name   
	ON { table | view }   
	[ WITH <dml_trigger_option> [ ,...n ] ]  
	{ FOR | AFTER | INSTEAD OF }   
	{ [ INSERT ] [ , ] [ UPDATE ] [ , ] [ DELETE ] }   
	[ WITH APPEND ]  
	[ NOT FOR REPLICATION ]   
	AS { sql_statement  [ ; ] [ ,...n ] | EXTERNAL NAME <method specifier [ ; ] > }  
  
	<dml_trigger_option> ::=  
		[ ENCRYPTION ]  
		[ EXECUTE AS Clause ]  
  
	<method_specifier> ::=  
		assembly_name.class_name.method_name */

create table topic4.products (
	productId integer identity(1,1) primary key,
	productName nvarchar(50) not null,
	price numeric(6,2) not null
);
go

-- Create a trigger topic4.trgPrintInsertedProduct on table topic4.products that is fired after an insert.
create or alter trigger topic4.trgPrintInsertedProduct
on topic4.products
after insert
as begin
	select * from inserted;
end;

-- Test the trigger. It must be fired by what triggers it - in this case, an insert statement.
insert topic4.products
	(productName, price)
values
	('OnePlus', 700);

drop trigger topic4.trgPrintInsertedProduct; -- Remove trigger.
go

-- Create a trigger topic4.trgPrintDeletedProduct on table topic4.products that is fired after a delete.
create or alter trigger topic4.trgPrintDeletedProduct
on topic4.products
after delete
as begin
	select * from deleted;
end;

delete from topic4.products;
go

-- Create a trigger topic4.trgPrintUpdatedProject on table topic4.products that is fired after an update.
create or alter trigger topic4.trgPrintUpdatedProject
on topic4.products after update
as begin
	select * from deleted;
	select * from inserted;
end;

update topic4.products
set price = 900
where productName = 'OnePlus';
go

/*
 | operation	| deleted table						| inserted table
 -------------------------------------------------------------------------------------
 | INSERT       | (not used)						| contains the rows being inserted
 | DELETE		| contains the rows being deleted	| (not used)
 | UPDATE		| before the UPDATE statement		| after UPDATE statement */

-- Modify the previous trigger so that the productName, oldPrice, newPrice and price difference are shown.
create or alter trigger topic4.trgPrintUpdatedProject
on topic4.products after update
as begin
	select i.productName as 'Product', d.price as 'Old Price', i.price as 'New Price', (i.price - d.price) as 'Price Difference'
	from deleted d inner join inserted i
		on d.productId = i.productId;
end;

update topic4.products
set price = 1300
where productName = 'OnePlus';
go

/* Create a trigger that is inserted before a product is inserted. 
   If the price is from 100 to 1000, insert the product.
   Otherwise, print "Invalid price". */
create or alter trigger topic4.trgValidatePriceBeforeInserting
on topic4.products instead of insert
as begin
	declare @price as numeric(6,2) = (select price from inserted);
	if(@price between 100 and 1000)
	begin
		insert into topic4.products
		select productName, price from inserted;

		select productName, price from inserted;
	end
	else
		print('Invalid price');
end;

select * from topic4.products;

insert topic4.products
	(productName, price)
values
	('Nokia 3310', 120);