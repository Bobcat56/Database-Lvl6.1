use dp2;

-- Only topic3.userAccount and topic3.accountStatus are filled in at this stage.
select * from topic3.userAccount;
select * from topic3.accountStatus;
select * from topic3.sessionLog;
select * from topic3.sessionAudit;
go

-- Q1: Create a stored procedure to create a new account status. Return the newly generated id.
create or alter procedure topic3.addAccountStatus(@accountStatus nvarchar(50), @statusId tinyint output)
as begin
	set nocount on;
	insert into topic3.accountStatus
		(statusName)
	values
		(@accountStatus);

	select @statusId = scope_identity();
end;
go

-- Q2: Test procedure.
begin
	declare @statusId tinyint;
	exec topic3.addAccountStatus 'Blocked', @statusId output;
	print @statusId
end;
go

-- Q3: Remove the row count from the procedure.
create or alter procedure topic3.addAccountStatus(@accountStatus nvarchar(50), @statusId tinyint output)
as begin
	set nocount on;
	insert into topic3.accountStatus
		(statusName)
	values
		(@accountStatus);

	select @statusId = scope_identity();
end;
go

-- Q4: Test procedure.
begin
	declare @statusId tinyint;
	exec topic3.addAccountStatus 'Banned', @statusId output;
	print @statusId
end;
go

-- Q5: Does user exist? Create a function that accepts the username and returns a bit if user exists or not.
create or alter function topic3.doesUserExist(@username nvarchar(45))
returns bit
as begin
	return (select count(*)
			from topic3.userAccount
			where accountUsername = @username);
end;
go

select topic3.doesUserExist('joeb'),
	   topic3.doesUserExist('alang');
go

-- Q6: Is account active? Create a function that checks if an account is active or not by passing the username as a parameter.
create or alter function topic3.isAccountActive(@username nvarchar(45))
returns bit
as begin
	return (select count(*)
			from topic3.userAccount ua inner join topic3.accountStatus [as]
				on ua.statusId = [as].statusId
			where ua.accountUsername = @username and [as].statusName = 'Active')
end;
go

select topic3.isAccountActive('lisag'),
	   topic3.isAccountActive('joeb'),
	   topic3.isAccountActive('tonyz');
go

/* Q7: Create a function that returns the sessionId if the user is logged in, otherwise return null.
   Filter by username, order by entryDate desc and isLogin asc. Pick the first row. */
create or alter function topic3.isUserLoggedIn
	(@username nvarchar(45))
returns bigint
as begin
	declare @sessionId bigint = null;
	declare @isLogin bit = 0;

	select top 1 @sessionId =  sl.sessionId, @isLogin = sl.isLogin
	from topic3.sessionLog sl inner join topic3.userAccount ua
		on sl.accountId = ua.accountId
	where accountUsername = @username
	order by entryDate desc, isLogin asc;

	if @isLogin = 0
		set @sessionId = null
	return @sessionId;
end;
go

/* Q8: Create a stored procedure that accepts isLogin, isSuccesful, sessionLogin, loginMessage and username, and populates sessionAudit with the given parameters. 
       auditDate date must be current date with offset. */
create or alter procedure topic3.auditSessionLogin
	(@isLogin bit, @isSuccessful bit, @sessionLogin bigint, @loginMessage nvarchar(45), @username nvarchar(45))
as begin
	insert into topic3.sessionAudit
		(auditDate, isLogin, isSuccessful, sessionId, loginMessage, accountUsername)
	values
		(sysdatetimeoffset(), @isLogin, @isSuccessful, @sessionLogin, @loginMessage, @username);
end;

/* Q9: Create a sequence seqSessionId that:
        - starts from 1
		- increments by 1
		- has no minimum or maximum value
		- does not cycle
		- caches the first 1000 values. */
create sequence topic3.seqSessionId
start with 1
increment by 1
no minvalue
no maxvalue
no cycle
cache 1000;
go

-- Q10
create or alter procedure topic3.spLogin
	(@username nvarchar(45))
as begin
	set nocount on;

	-- Check if user exists.
	if(topic3.doesUserExist(@username) = 0)
	begin
		execute topic3.auditSessionLogin 1, 0, null, 'User does not exist!', @username
		return; -- Stop control flow, thus exit stored procedure.
	end

	-- Check if user is active.
	if(topic3.isAccountActive(@username) = 0)
	begin
		execute topic3.auditSessionLogin 1, 0, null, 'User is not active!', @username
		return; -- Stop control flow, thus exit stored procedure.
	end;

	declare @sessionId bigint = topic3.isUserLoggedIn(@username);

	-- If @sessionId has a value, then it means that the user is logged in. Therefore, we have to log the user out.
	if(@sessionId is not null)
	begin
		-- Log out user.
		insert into topic3.sessionLog
			(entryDate, isLogin, sessionId, accountId)
		values
			(sysdatetimeoffset(), 0, @sessionId,
				(select accountId
				 from topic3.userAccount
				 where accountUsername = @username)
			);

		execute topic3.auditSessionLogin 0, 1, @sessionId, 'User successfully logged out', @username;
	end

	set @sessionId = next value for topic3.seqSessionId -- Get a new session id

	-- Login user.
		insert into topic3.sessionLog
			(entryDate, isLogin, sessionId, accountId)
		values
			(sysdatetimeoffset(), 1, @sessionId,
				(select accountId
				 from topic3.userAccount
				 where accountUsername = @username)
			);

		execute topic3.auditSessionLogin 1, 1, @sessionId, 'User successfully logged in', @username;
end;

execute topic3.spLogin 'peter'; -- Test user that does not exist.
execute topic3.spLogin 'tonyz'; -- Test user which is inactive.

-- When testing out the following query after the first time, joeb will be logged out and back in.
execute topic3.spLogin 'joeb'; -- Test successful login;

select * from topic3.sessionAudit;
select * from topic3.sessionLog;