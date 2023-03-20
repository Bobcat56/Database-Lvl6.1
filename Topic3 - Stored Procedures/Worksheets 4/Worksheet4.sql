use dp2;
go

create or alter function wk04.doesOrderExist
	(@orderId integer)
returns bit
as begin
	return (select count(*)
		    from wk04.[Order]
		    where orderId = @orderId);
end;
go

create or alter function wk04.isUserActive
	(@username nvarchar(45))
returns bit
as begin
	return (select count(*)
            from wk04.userAccount ua inner join wk04.accountStatus [as]
				on ua.statusId = [as].statusId
			where ua.username = @username and [as].statusName = 'Active')
end;
go

create or alter procedure wk04.auditPayment
	(@paymentId integer, @orderId integer, @orderTotal numeric(6,2), @paidToDate numeric(6,2), @paymentAmount numeric(6,2), @isValid bit, @paymentMessage nvarchar(45))
as begin
	insert into wk04.paymentLog
		(paymentId, orderId, orderTotal, paidToDate, paymentAmount, paymentDate, IsValid, paymentMessage)
	values
		(@paymentId, @orderId, @orderTotal, @paidToDate, @paymentAmount, sysdatetimeoffset(), @isValid, @paymentMessage);
end;
go

create or alter function wk04.isOrderPaid
	(@orderId integer)
returns bit
as begin
	return (select count(*)
	        from wk04.[Order] o inner join wk04.orderStatus os
				on o.statusId = os.statusId
			where orderId = @orderId and os.statusName = 'Paid in full')
end;
go

create or alter function wk04.isPaymentValid
	(@amount numeric(6,2))
returns bit
as begin
	return (select iif(@amount > 500 or @amount <= 0, 0, 1));
end;
go

create or alter procedure wk04.processPayment
	(@username nvarchar(45), @amount numeric(6,2), @orderId integer)
as begin
	set nocount on;
end;
go