use dp2;
go

-- Question 1
create or alter function wk02.udf_isValidAmount(@amount numeric(6,2))
returns bit
begin
	return (select iif(@amount between 50 and 500, 1, 0))
end
go

-- Question 2
select wk02.udf_isValidAmount(-50) as '-50',
	wk02.udf_isValidAmount(0) as '0',
	wk02.udf_isValidAmount(50) as '50',
	wk02.udf_isValidAmount(500) as '500';
go

-- Question 3
create or alter function wk02.udf_isUserActive(@username nvarchar(50))
returns bit
begin
	return (
		select iif(statusName = 'Active', 1, 0)
		from wk02.accountStatus [as] inner join wk02.userAccount ua
			on [as].statusId = ua.statusId
		where ua.Username = @username
	)
end
go

-- Question 4
select ua.Username, [as].statusName, wk02.udf_isUserActive(ua.Username) as 'isUserActive'
from wk02.userAccount ua inner join wk02.accountStatus [as]
	on ua.statusId = [as].statusId;
go

-- Question 5
create or alter function wk02.displayOrderTotal(@orderId integer)
returns numeric(8,2)
as begin
return (select sum(pr.unitPrice * oi.Quantity)
		from wk02.Product pr inner join wk02.orderItem oi
			on pr.productId = oi.productId
			inner join wk02.[Order] o
			on oi.orderId = o.orderId
		where o.orderId = @orderId);
end;
go

-- Question 6
select o.orderId as 'Order Id', wk02.displayOrderTotal(o.orderId) as 'Order Total'
from wk02.[Order] o;
go

-- Question 7
create or alter function wk02.udf_getValidPayments(@orderId integer)
returns numeric(6,2)
as begin
	declare @totalValidPayments as integer = (select isnull(sum(p.paymentAmount), 0)
											  from wk02.Payment p inner join wk02.[Order] o
													on p.orderId = o.orderId
											  where p.orderId = @orderId and isValid = 1)
	return @totalValidPayments
end;
go

-- Question 8
select o.orderId as 'Order Id', 
	wk02.displayOrderTotal(o.orderId) as 'Order Total', 
	wk02.udf_getValidPayments(o.orderId) as 'Valid Payments'
from wk02.[Order] o;
go

-- Question 9
create or alter function wk02.udf_getPendingOrders(@accountId integer)
returns table
as begin
	return (
		select o.orderId, o.orderDate, o.accountId, o.statusId, os.statusName
		from wk02.[Order] o inner join wk02.[orderStatus] os
			on o.statusId = os.statusId
		where o.accountId = @accountId
	)
end;
go