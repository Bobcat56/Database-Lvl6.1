-- https://learn.microsoft.com/en-us/sql/t-sql/statements/create-function-transact-sql?view=sql-server-ver16

/* Syntax to create a function for Transact-SQL
CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name
( [ { @parameter_name [ AS ][ type_schema_name. ] parameter_data_type [ NULL ]
 [ = default ] [ READONLY ] }
    [ ,...n ]
  ]
)
RETURNS return_data_type
    [ WITH <function_option> [ ,...n ] ]
    [ AS ]
    BEGIN
        function_body
        RETURN scalar_expression
    END
[ ; ]
*/

use dp2;
go

-- Create a function that accepts a number and returns its squared value.
create or alter function dbo.squareNum(@number integer)
returns integer
as
begin
	return @number * @number;
end;
go

select dbo.squareNum(6);
go

-- Create a function that accepts name and surname and returns full name with good morning.
create or alter function dbo.greetUser(@name nvarchar(50), @surname nvarchar(50))
returns nvarchar(max)
as
begin
	return concat('Good morning, ', @name, ' ', @surname, '!');
end;
go

select dbo.greetUser('Mandy', 'Farrrugia');
go

/* Create a function that accepts a name and age. 
 * If age is less than 17, display the message "Have a milkshake, [name]", else "Have a beer, [name]." */
create or alter function dbo.printMessage(@name nvarchar(50), @age integer)
returns nvarchar(max)
as
begin
	if @age < 17
		return concat('Have a milkshake, ', @name);
	return concat('Have a beer, ', @name);
end;
go

select dbo.printMessage('Mandy', 21);
go

-- Create a function that accepts the date of birth and returns your age in years.
create or alter function dbo.getAgeFromDateOfBirth(@dateOfBirth nvarchar(20))
returns integer
as
begin
	declare @age as integer = datediff(year, @dateOfBirth, getdate())
	if(month(getdate()) < month(@dateOfBirth))
		set @age = @age - 1;
	else if(month(getdate()) = month(@dateOfBirth))
	begin
		if(day(getdate()) < day(@dateOfBirth))
			set @age = @age - 1;
	end;

	return @age;
end;
go

select dbo.getAgeFromDateOfBirth('2001-12-05');
go

/* Modify the previous function so that it accepts interval as well (year or month) and returns age accordingly. 
 * If year or month are not chosen, it returns an error message. */
create or alter function dbo.getAgeFromDateOfBirth(@dateOfBirth nvarchar(20), @interval nvarchar(10))
returns nvarchar(100)
as
begin
	declare @age as integer = 0;

	if @interval = 'Year'
	begin
		set @age = datediff(year, @dateOfBirth, getdate())
		if(month(getdate()) < month(@dateOfBirth))
			set @age = @age - 1;
		else if(month(getdate()) = month(@dateOfBirth))
		begin
			if(day(getdate()) < day(@dateOfBirth))
				set @age = @age - 1;
		end
		return concat('You are ', @age, ' years old.');
	end
	else if @interval = 'Month'
	begin
		set @age = datediff(month, @dateOfBirth, getdate())
		return concat('You are ', @age, ' months old.');
	end;

	return 'Age must be either in years or months!';
end;
go

select dbo.getAgeFromDateOfBirth('2001-12-05', 'month');
select dbo.getAgeFromDateOfBirth('2001-12-05', 'year');